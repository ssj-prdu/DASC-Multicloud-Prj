############# route 53 생성 ##############
resource "aws_route53_zone" "dasc_zone" {
  name = var.domain_name  # 본인의 도메인 이름으로 변경하세요.

  tags = {
    Name = "dasc-route53"
  }
}
############ ns 레코드 생성 ############
resource "aws_route53_record" "ns" {
  zone_id = aws_route53_zone.dasc_zone.zone_id
  name    = "ns.${var.domain_name}"  # 생성할 서브 도메인 이름
  type    = "CNAME"
  ttl     = 300
  records = [ aws_cloudfront_distribution.cloudfront.domain_name ]
}
# ############ www 레코드 생성 ############
# resource "aws_route53_record" "A" {
#   zone_id = aws_route53_zone.dasc_zone.zone_id
#   name    = "www.${var.domain_name}"  # 생성할 서브 도메인 이름
#   type    = "A"
#   ttl     = 300
#   records = [ "GCP LB IP" ]
# }