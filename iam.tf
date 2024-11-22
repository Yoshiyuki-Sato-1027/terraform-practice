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
  # statement {
  #   effect    = "Allow"
  #   actions   = data.aws_iam_policy.ecs_task_execution_role_policy.policy_actions
  #   resources = data.aws_iam_policy.ecs_task_execution_role_policy.policy_resources
  # }
}

data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions"] # リージョン一覧を取得する  
    resources = ["*"]
  }

}


# ec2のiam
module "describe_regions_for_ec2" {
  source   = "./iam_role"
  name     = "describe-regions-for-ec2"
  identify = "ec2.amazonaws.com"
  policy   = data.aws_iam_policy_document.allow_describe_regions.json
}

# resource "aws_ecs_task_definition" "example" {
#   family                   = "example"
#   cpu                      = "256"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   container_definitions    = file("./container_definitions.json")
#   execution_role_arn       = module.ecs_task_execution_role.iam_role_arn
# }
