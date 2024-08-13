output "s3_bucket_website_endpoint" {
  value = aws_s3_bucket.dasc-s3-web.website_endpoint
  description = "The website endpoint URL for the S3 bucket"
}