# AWS ECS Fargate Service & Step/Target Tracking Autoscaling for R$ 7M/mo ML Model Serving

variable "environment" {
  type    = string
  default = "production"
}

variable "vpc_subnet_ids" {
  type    = list(string)
  default = ["subnet-0a1b2c3d4e5f6g7h8", "subnet-0a1b2c3d4e5f6g7h9"]
}

variable "security_group_ids" {
  type    = list(string)
  default = ["sg-0a1b2c3d4e5f6g7h8"]
}

variable "target_group_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/ml-tg/1234567890"
}

resource "aws_ecs_cluster" "ml_cluster" {
  name = "ml-serving-cluster-${var.environment}"
}

resource "aws_ecs_task_definition" "ml_task" {
  family                   = "ml-inference-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::123456789012:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "ml-inference-api"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/ml-revenue-model:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      environment = [
        { name = "DD_ENV", value = var.environment },
        { name = "DD_SERVICE", value = "ml-inference-service" }
      ]
    }
  ])
}

resource "aws_ecs_service" "ml_service" {
  name            = "ml-inference-service-${var.environment}"
  cluster         = aws_ecs_cluster.ml_cluster.id
  task_definition = aws_ecs_task_definition.ml_task.arn
  desired_count   = 4
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.vpc_subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "ml-inference-api"
    container_port   = 8000
  }
}

# Autoscaling target & policies (Step Scaling + Target Tracking -23% FinOps)
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 20
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.ml_cluster.name}/${aws_ecs_service.ml_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_target_tracking_cpu" {
  name               = "ecs-target-tracking-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 65.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}

output "service_name" {
  value = aws_ecs_service.ml_service.name
}

output "cluster_name" {
  value = aws_ecs_cluster.ml_cluster.name
}
