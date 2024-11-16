variable "name" { type = string }
variable "identify" { type = string }
variable "policy" { type = string }

resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identify]
    }
  }
}

resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

output "aws_iam_role_arn" {
  value = aws_iam_role.default.arn

}

output "iam_role_name" {
  value = aws_iam_role.default.name
}

# ec2のiam
module "describe_regions_for_ec2" {
  source   = "./iam_role"
  name     = "describe-regions-for-ec2"
  identify = "ec2.amazonaws.com"
  policy   = data.aws_iam_policy_document.allow_describe_regions.json
}