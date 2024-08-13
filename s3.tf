resource "aws_s3_bucket" "dasc-s3-tfstate-jh" {
  bucket = "dasc-s3-tfstate"
  acl = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }


  
}
