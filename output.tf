output "exam_site" {
  value = aws_s3_bucket_website_configuration.exam_site.website_endpoint
  description = "The website endpoint URL for the S3 bucket"
}