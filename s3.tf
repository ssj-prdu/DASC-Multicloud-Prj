################## Web hosting S3 ###############
resource "aws_s3_bucket" "dasc-s3-web" {
  bucket = "dasc-s3-web"  # 고유한 S3 버킷 이름으로 변경

  tags = {
    Name        = "dasc-s3-web"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_website_configuration" "dasc-s3-web" {
  bucket = aws_s3_bucket.dasc_s3_web.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket.dasc_s3_web]  # 의존성 명시
}


# S3 버킷 정책 - 퍼블릭으로 읽기 가능하도록 설정
resource "aws_s3_bucket_policy" "dasc-s3-web" {
  bucket = aws_s3_bucket.dasc-s3-web.id

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::dasc-s3-web/*"
    }
  ]
})
}