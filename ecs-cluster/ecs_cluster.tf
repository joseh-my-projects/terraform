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

resource "aws_ecs_service" "ecs_nginx_service" {
  name            = "my-nginx-service"
  cluster         = aws_ecs_cluster.my_ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [module.vpc.subnet1_id, module.vpc.subnet2_id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.id
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.ecs_alb_listener]
}