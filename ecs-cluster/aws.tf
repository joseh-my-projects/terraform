module "vpc" {
  source = "./../modules/vpc"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "ECS-sg"
  description = "Ports needed for ECS"

  tags = {
    Name = "ECS_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.ecs_sg.id
  for_each          = local.ingress_rules
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_lb" "ecs_lb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]

  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_lb_listener" "ecs_alb_80" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue_ecs_tg.id
        weight = 100
      }
      target_group {
        arn    = aws_lb_target_group.green_ecs_tg.id
        weight = 0
      }
    }
  }
}

resource "aws_lb_listener" "ecs_alb_8080" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type = "forward"

    forward {
      target_group {
        arn    = aws_lb_target_group.blue_ecs_tg.id
        weight = 0
      }
      target_group {
        arn    = aws_lb_target_group.green_ecs_tg.id
        weight = 100
      }
    }
  }
}

resource "aws_lb_listener_rule" "path_based_80" {
  listener_arn = aws_lb_listener.ecs_alb_80.arn
  priority     = 99

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.blue_ecs_tg.arn
        weight = 100
      }

      target_group {
        arn    = aws_lb_target_group.green_ecs_tg.arn
        weight = 0
      }
    }
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "path_based_8080" {
  listener_arn = aws_lb_listener.ecs_alb_8080.arn
  priority     = 99

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.blue_ecs_tg.arn
        weight = 0
      }

      target_group {
        arn    = aws_lb_target_group.green_ecs_tg.arn
        weight = 100
      }
    }
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_target_group" "blue_ecs_tg" {
  name        = "blue-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "green_ecs_tg" {
  name        = "green-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    path = "/"
  }
}






