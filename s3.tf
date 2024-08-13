################## Web hosting S3 ###############
resource "aws_s3_bucket" "static_website" {
  bucket = "dasc-s3-web"
  acl    = "public-read"

  website {
    index_document = "main.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "jhtest-s3-web"
  }
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.bucket

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.static_website.bucket}/*"
    }
  ]
}
POLICY
}