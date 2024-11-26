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


data "aws_iam_policy_document" "codebuild" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
  }
}

resource "aws_iam_instance_profile" "ec2_for_ssm" {
  name = "ec2-for-ssm"
  role = module.ec2_for_ssm_role.iam_role_name
}

data "aws_iam_policy_document" "ec2_for_ssm" {
  source_json = data.aws_iam_policy.ec2_for_ssm.policy

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:PutObject",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "kms:Decrypt",
    ]
  }
}

data "aws_iam_policy" "ec2_for_ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
