################## Web hosting S3 ###############
resource "aws_s3_bucket" "dasc-s3-web" {
  bucket = "dasc-s3-web"  # 고유한 S3 버킷 이름으로 변경하세요.
  acl    = "public-read"

  tags = {
    Name = "dasc-s3-web"
  }
}

resource "aws_s3_bucket_website_configuration" "dasc-s3-web" {
  bucket = aws_s3_bucket.dasc-s3-web.id

  index_document {
    suffix = "main.html"  # 기본 문서 설정
  }

  error_document {
    key = "error.html"  # 오류 시 표시할 문서 설정
  }
}