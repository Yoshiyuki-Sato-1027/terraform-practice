# プライベートバケット
resource "aws_s3_bucket" "private" {
  bucket = "private-pragmatic-terraform1"
}

resource "aws_s3_bucket_versioning" "private" {
  bucket = aws_s3_bucket.private.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "private" {
  bucket = aws_s3_bucket.private.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# パブリックバケット
# 実践terraformから手直ししてる

# バケット定義
resource "aws_s3_bucket" "public" {
  bucket = "public-pragmatic-terraform2"
}

resource "aws_s3_bucket_ownership_controls" "public" {
  bucket = aws_s3_bucket.public.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public" {
  bucket = aws_s3_bucket.public.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ACLの設定
resource "aws_s3_bucket_acl" "public" {
  depends_on = [
    aws_s3_bucket_ownership_controls.public,
    aws_s3_bucket_public_access_block.public,
  ]
  bucket = aws_s3_bucket.public.id
  acl    = "public-read"

}

# corsの設定
resource "aws_s3_bucket_cors_configuration" "public" {
  bucket = aws_s3_bucket.public.id

  cors_rule {
    allowed_origins = ["https://public.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

# ALBのログ保存
resource "aws_s3_bucket" "alb_log" {
  bucket = "alb-log-pragmatic-terraform3"
}

resource "aws_s3_bucket_lifecycle_configuration" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id

  rule {
    id     = "log_expiration"
    status = "Enabled"

    expiration {
      days = 180
    }
  }
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

# バケットポリシーを定義
data "aws_iam_policy_document" "alb_log" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]
    principals {
      type        = "AWS"
      identifiers = ["807933607169"]
    }
  }
}

# force_destroy = trueによって、S3にオブジェクトが入っていても矯正削除できる
# resource "aws_s3_bucket" "force_destroy" {
#   bucket = "force-destroy-pragmatic-terraform4"
#   force_destroy = true
# }