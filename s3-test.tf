resource "aws_s3_bucket" "bucket_test" {
  bucket = "jhtest-bucket-test"
}

resource "aws_s3_bucket_acl" "bucket_test" {
  bucket = aws_s3_bucket.bucket_test.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "bucket_test" {
  bucket = aws_s3_bucket.bucket_test.id

  index_document {
    suffix = "main.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_policy" "bucket_test" {
  bucket = aws_s3_bucket.bucket_test.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid       = "AllowPublic"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket_test.arn}/**"
      }
    ]
  })
}