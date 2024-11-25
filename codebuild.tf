resource "aws_codebuild_project" "example" {
  name         = "example"
  service_role = module.codebuild_role.iam_role_arn

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    type            = "LINUX_CONTAINER"
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:2.0"
    privileged_mode = true
  }
}


module "codebuild_role" {
  source   = "./iam_role"
  name     = "codebuild"
  identify = "codebuild.amazonaws.com"
  policy   = data.aws_iam_policy_document.codebuild.json
}
