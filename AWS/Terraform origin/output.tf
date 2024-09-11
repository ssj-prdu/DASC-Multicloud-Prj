output "bucket_endpoint" {
  value = aws_s3_bucket_website_configuration.exam_site.website_endpoint
  description = "The website endpoint URL for the S3 bucket"
}

output "cloudfront_endpoint" {
    value = aws_cloudfront_distribution.cloudfront.domain_name
}