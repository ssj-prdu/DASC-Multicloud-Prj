################## Web hosting S3 ###############
resource "aws_s3_bucket" "bucket" {
  bucket = "dasc-s3-web"  # 고유한 S3 버킷 이름으로 변경하세요.

  tags = {
    Name = "dasc-s3-web"
  }
}
########## public access 허용 ############
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
########## 웹 호스팅 ############
resource "aws_s3_bucket_website_configuration" "exam_site" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "main.html"  # 기본 문서 설정
  }
  error_document {
    key = "error.html"  # 오류 시 표시할 문서 설정
  }
}


resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::dasc-s3-web/*"
        }
    ]
  })
}