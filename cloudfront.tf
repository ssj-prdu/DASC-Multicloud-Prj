################## CloudFront Distribution ##################
resource "aws_s3_bucket_website_configuration" "dasc_s3_web" {
  bucket = aws_s3_bucket.dasc-s3-web.id

  index_document {
    suffix = "main.html"  # 기본 문서 설정
  }

  error_document {
    key = "error.html"  # 오류 시 표시할 문서 설정
  }
}

resource "aws_cloudfront_distribution" "dasc_s3_web_distribution" {
  origin {
    domain_name = aws_s3_bucket.dasc-s3-web.website_endpoint
    origin_id   = "S3-dasc-s3-web"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"  # HTTP only로 설정
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