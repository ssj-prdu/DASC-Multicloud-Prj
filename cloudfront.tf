################## CloudFront Distribution ##################
resource "aws_cloudfront_distribution" "dasc-s3-web-distribution" {
  origin {
    domain_name = output.exam_site
    origin_id   = "S3-dasc-s3-web"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"  # HTTP only로 설정
      origin_ssl_protocols   = ["TLSv1.2"]  # 필수 속성 추가
    }
  }


  enabled             = true
  is_ipv6_enabled     = false
  comment             = "CloudFront distribution for S3 web hosting"
  default_root_object = "main.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-dasc-s3-web"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"  # HTTP 요청을 HTTPS로 리디렉션
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true  # 객체 자동 압축
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "dasc-s3-web-distribution"
  }
}