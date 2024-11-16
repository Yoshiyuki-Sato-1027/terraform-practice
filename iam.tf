# ポリシードキュメントの定義
data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeRegions"
    ]

    resources = ["*"]

  }
}

# IAMポリシーの定義
resource "aws_iam_policy" "example" {
  name   = "example"
  policy = data.aws_iam_policy_document.example.json
}

# 信頼ポリシー(なんのサービスに関連付けるか)の定義
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAMロールの定義
resource "aws_iam_role" "example" {
  name               = "example"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# IAMポリシーのアタッチ
# IAMポリシーとIAMロールは関連付けないと機能しない
resource "aws_iam_role_policy_attachment" "example" {
  role       = aws_iam_role.example.name
  policy_arn = aws_iam_policy.example.arn
}