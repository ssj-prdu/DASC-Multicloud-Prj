################## Web hosting S3 ###############
resource "aws_s3_bucket" "dasc-s3-web" {
  bucket = "dasc-s3-web"  # 버킷 이름을 고유하게 설정하세요.

  # 웹 호스팅을 위한 설정
  website {
    index_document = "main.html"  # 기본 문서
    error_document = "error.html"  # 오류 시 표시할 문서
  }

  tags = {
    Name = "dasc-s3-web"
  }
}

# S3 버킷 정책 - 퍼블릭으로 읽기 가능하도록 설정
resource "aws_s3_bucket_policy" "dasc-s3-web" {
  bucket = aws_s3_bucket.dasc-s3-web.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.dasc-s3-web.arn}/*"
      }
    ]
  })
}