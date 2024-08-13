################## Web hosting S3 ###############
resource "aws_s3_bucket" "dasc_s3_web" {
  bucket = "dasc-s3-web"  # 고유한 S3 버킷 이름으로 변경하세요.

  tags = {
    Name        = "dasc-s3-web"
  }
}

resource "aws_s3_bucket_website_configuration" "dasc_s3_web" {
  bucket = aws_s3_bucket.dasc_s3_web.id

  index_document {
    suffix = "main.html"  # 기본 문서 설정
  }

  error_document {
    key = "error.html"  # 오류 시 표시할 문서 설정
  }
}

# S3 버킷 정책 - 퍼블릭으로 읽기 가능하도록 설정
resource "aws_s3_bucket_policy" "dasc_s3_web" {
  bucket = aws_s3_bucket.dasc_s3_web.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.dasc_s3_web.arn}/*"
      }
    ]
  })
}