resource "aws_ecs_task_definition" "def" {
  family                = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  execution_role_arn       = aws_iam_role.tasks-service-role.arn
  memory                   = var.fargate_memory
  container_definitions = <<TASK_DEFINITION
  [
    {
      "cpu": 256,
      "environment": [
          {"name": "NODE_ENV", "value": "production"},
          {"name": "database__client", "value": "mysql"},
          {"name": "database__connection__host", "value": "${var.db_host}"},
          {"name": "database__connection__port", "value": "3306"},
          {"name": "database__connection__user", "value": "${var.db_user}"},
          {"name": "database__connection__password", "value": "${var.db_password1}"},
          {"name": "database__connection__database", "value": "${var.family}"}
      ],
      "essential": true,
      "image": "${aws_ecr_repository.image_repo.repository_url}",
      "memory": 512,
      "name": "ghostproduction",
      "portMappings": [
        {
          "containerPort": 2368,
          "hostPort": 2368
        }
      ],
      "mountPoints": [
        {
          "sourceVolume": "efs",
          "containerPath": "/var/lib/ghost"
        }
      ]
    }
  ]
  TASK_DEFINITION
  volume {
    name = "efs"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.efs.id
      root_directory = "/"
    }
  }
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "${var.stack}-Cluster"
}



#######3
resource "aws_ecs_service" "service" {
  name            = "${var.stack}-Service"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.def.arn
  desired_count   = var.task_count
  launch_type     = "FARGATE"
  health_check_grace_period_seconds = 300

  network_configuration {
    security_groups = [aws_security_group.task-sg.id]
    subnets         = aws_subnet.private.*.id
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.trgp.id
    container_name   = var.family
    container_port   = var.container_port
  }

  depends_on = [
    aws_alb_listener.alb-listener
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUDWATCH LOG GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "nordcloud-cw-lgrp" {
  name = var.cw_log_group
}