resource "aws_route53_zone" "dasc_zone" {
  name = "chjy0623.shop"  # 본인의 도메인 이름으로 변경하세요.

  tags = {
    Name = "dasc-route53"
  }
}

resource "aws_route53_record" "ns" {
  zone_id = aws_route53_zone.dasc_zone.zone_id
  name    = "ns.chjy0623.shop"  # 생성할 서브 도메인 이름
  type    = "CNAME"
  ttl     = 300
  records = [ output.cloudfront_dns ]
}