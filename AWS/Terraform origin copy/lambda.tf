######################### exam check ###########################
module "examcheck" {
  prefix  = "examcheck"
  source  = "./lambda_infra"
  runtime = "python3.9"

  filename           = "${path.module}/lambda_code/examcheck.zip"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.lambda_examcheck.id]

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator",
    "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
  ]

  env_vars = {
    # DB_PASSWORD = var.db_password
  }
}

######################### logs ###########################
module "logs" {
  prefix  = "logs"
  source  = "./lambda_infra"
  runtime = "python3.9"

  filename           = "${path.module}/lambda_code/logs.zip"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.lambda_examcheck.id]

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]

  env_vars = {
  }
}

######################### rdssnapshot ###########################
module "rdssnapshot" {
  prefix  = "rdssnapshot"
  source  = "./lambda_infra"
  runtime = "python3.9"

  filename           = "${path.module}/lambda_code/rdssnapshot.zip"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.lambda_examcheck.id]

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]

  env_vars = {
    # DB_PASSWORD = var.db_password
  }
}

######################### SES ###########################
module "ses" {
  prefix  = "lambda-examcheck"
  source  = "./lambda_infra"
  runtime = "python3.9"

  filename           = "${path.module}/lambda_code/ses.zip"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.lambda_examcheck.id]

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
    "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  ]

  env_vars = {
    # DB_PASSWORD = var.db_password
  }
}