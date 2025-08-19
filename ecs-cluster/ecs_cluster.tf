resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "my-ecs-task"
  network_mode             = "awsvpc"
  execution_role_arn       = "arn:aws:iam::573055573761:role/ecsTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "${data.aws_ecr_repository.ecr_repo.repository_url}:nginx-v1"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_test_service" {
  name                          = "my-sample-service"
  cluster                       = aws_ecs_cluster.my_ecs_cluster.id
  task_definition               = aws_ecs_task_definition.ecs_task.arn
  desired_count                 = 1
  launch_type                   = "FARGATE"
  availability_zone_rebalancing = "ENABLED"

  deployment_configuration {
    strategy             = "BLUE_GREEN"
    bake_time_in_minutes = 5
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blue_ecs_tg.arn
    container_name   = "nginx"
    container_port   = 80

    advanced_configuration {
      alternate_target_group_arn = aws_lb_target_group.green_ecs_tg.arn
      production_listener_rule   = aws_lb_listener_rule.path_based_80.arn
      role_arn                   = "arn:aws:iam::573055573761:role/ecs-lb-role"
      test_listener_rule         = aws_lb_listener_rule.path_based_8080.arn
    }
  }

  lifecycle {
    ignore_changes = all
  }
}


#   lifecycle {
#     ignore_changes = [desired_count]
#   }

#   depends_on = [aws_lb_listener.ecs_alb_listener]
# }