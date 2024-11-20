data "aws_iam_policy" "ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters", "kms:Decrypt"]
    resources = ["*"]
  }

  # マネージドポリシーをインラインポリシーに取り込む
  statement {
    effect    = "Allow"
    actions   = data.aws_iam_policy.ecs_task_execution_role_policy.policy_actions
    resources = data.aws_iam_policy.ecs_task_execution_role_policy.policy_resources
  }
}


module "ecs_task_execution_role" {
  source   = "./iam_role"
  name     = "ecs-task-execution"
  identify = "ecs-tasks.amazonaws.com"
  policy   = data.aws_iam_policy_document.ecs_task_execution.json
}

resource "aws_ecs_task_definition" "example" {
  family                   = "example"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = file("./container_definitions.json")
  execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
}
