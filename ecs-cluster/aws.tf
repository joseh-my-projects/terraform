module "vpc" {
  source = "./modules/vpc"

  providers = {
    aws = aws
  }
}

resource "aws_security_group" "ecs_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "Allow http"
  description = "Allowing traffic on port 80"

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      description = ingress.key
      from_port = ingress.value.port
      to_port = ingress.value.port
      cidr_blocks = module.vpc.cidr_block

    }
    
  }

  tags = {
    Name = "ecs_sg"
  }
}



resource "aws_lb" "ecs_lb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.ecs_sg.id]
#  subnets = module.vpc.subnet_ids.*.id
  subnets = [module.vpc.subnet1_id, module.vpc.subnet2_id]

  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.id
  }
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "ecs-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path = "/"
  }
}


