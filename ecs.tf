resource "aws_ecs_cluster" "example" {
  name = "example"
}


resource "aws_ecs_task_definition" "example" {
  family                   = "example" # タスク定義名のプレフィクス
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc" # Fargateの場合は awsvpc を指定
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
}

resource "aws_ecs_service" "example" {
  name            = "example"
  cluster         = aws_ecs_cluster.example.arn
  task_definition = aws_ecs_task_definition.example.arn

  network_configuration {
    assign_public_ip = false
    security_groups  = [module.nginx_sg.security_group_id]

    subnets = [
      aws_subnet.private_0.id,
      aws_subnet.private_1.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.example.arn
    container_name   = "example"
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

module "nginx_sg" {
  source      = "./security_group"
  name        = "nginx-sg"
  vpc_id      = aws_vpc.example.id
  port        = 80
  cidr_blocks = [aws_vpc.example.cidr_block]
}
module "ecs_task_execution_role" {
  source   = "./iam_role"
  name     = "ecs-task-execution"
  identify = "ecs-tasks.amazonaws.com"
  policy   = data.aws_iam_policy_document.ecs_task_execution.json
}

resource "aws_ecs_task_definition" "example_batch" {
  family                   = "example-batch"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./batch_container_definitions.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}

data "aws_iam_policy" "ecs_events_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}

# ポリシー: リソースのアクセス許可をまとめたもの
module "ecs_events_role" {
  source   = "./iam_role"
  name     = "ecs-events"
  identify = "events.amazonaws.com"
  policy   = data.aws_iam_policy.ecs_events_role_policy.policy
}
