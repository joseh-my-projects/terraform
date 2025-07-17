module "vpc" {
  source = "./modules/vpc"
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners = ["amazon"] # Or other relevant owner IDs
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] # Example: Amazon Linux 2
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs_instance_profile"
  role = aws_iam_role.ecs_instance_role.name
}



resource "aws_launch_template" "ecs-lt" {
  name_prefix = "ecs-template"
  image_id = data.aws_ami.ecs_ami.id
  instance_type = var.instance_type
  
  key_name = "ecs-key"
  
  vpc_security_group_ids = [module.vpc.security_group_id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }

  user_data = filebase64("./ecs.sh")

}

resource "aws_autoscaling_group" "ecs_asg" {
  vpc_zone_identifier = [module.vpc.subnet1_id_public, module.vpc.subnet2_id_public]
  desired_capacity = 2
  max_size = 3
  min_size = 2

  launch_template {
    id = aws_launch_template.ecs-lt.id
    version = "$Latest"
  }

  tag {
    key = "AmazonECSManaged"
    value = true
    propagate_at_launch = true
  }
}

resource "aws_lb" "ecs_lb" {
  name = "ecs-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [module.vpc.security_group_id]
  subnets = [module.vpc.subnet1_id_public, module.vpc.subnet2_id_public]

  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port = 80
  protocol = "HTTP"
  
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name = "ecs-target-group"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = module.vpc.vpc_id

  health_check {
    path = "/"
  }
}


