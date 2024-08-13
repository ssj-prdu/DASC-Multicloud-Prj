################## Web hosting S3 ###############
resource "aws_s3_bucket" "dasc-s3-web" {
  bucket = "dasc-s3-web"  # 고유한 S3 버킷 이름으로 변경하세요.
  acl    = "public-read"

  tags = {
    Name        = "dasc-s3-web"
  }
}

resource "aws_s3_bucket_website_configuration" "dasc-s3-web" {
  bucket = aws_s3_bucket.dasc-s3-web.id

  index_document {
    suffix = "index.html"  # 기본 문서 설정
  }

  error_document {
    key = "error.html"  # 오류 시 표시할 문서 설정
  }
}

resource "aws_s3_bucket_policy" "dasc-s3-web-policy" {
  bucket = aws_s3_bucket.dasc-s3-web.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::dasc-s3-web/*"
      }
    ]
  })
}