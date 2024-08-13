
resource "aws_acm_certificate" "acm" {
  domain_name       = "chjy0623.shop"  # 본인의 도메인 이름으로 변경하세요.
  validation_method = "DNS"

  tags = {
    Name = "dasc-acm"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  zone_id = aws_route53_zone.dasc_zone.zone_id  # 본인의 Route 53 호스팅 영역 ID로 변경하세요.
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]

  depends_on = [ aws_route53_zone.dasc_zone ]
}

resource "aws_acm_certificate_validation" "dasc_cert_validation" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_record : record.fqdn]
}

##### 이거 하고 수동으로 Create record in Route53 눌러줬음 ######