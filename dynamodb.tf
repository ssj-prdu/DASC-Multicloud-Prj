resource "aws_dynamodb_table" "dasc-dynamo-tfstate-lock" {
  name         = "dasc-dynamo-tfstate-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
  server_side_encryption {
    enabled = true
}
}