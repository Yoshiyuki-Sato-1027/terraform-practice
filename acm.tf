
resource "aws_acm_certificate" "example" {
  domain_name               = aws_route53_record.example.name # ドメイン名
  subject_alternative_names = ["example.com"]
  validation_method         = "DNS" # 検証方法

  lifecycle {
    create_before_destroy = true
  }
}
