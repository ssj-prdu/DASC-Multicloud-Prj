# module "lambda" {
#   prefix  = "dasc"
#   source  = "./lambda_infra"
#   runtime = "python3.9"

#   filename           = "${path.module}/lambda_code/pymysql_layer.zip"
#   subnet_ids         = aws_subnet.dasc-subnet-private[*].id
#   security_group_ids = [aws_security_group.dasc-sg-lambda-exam.id]

#   policy_arns = [
#     "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
#     "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
#     "arn:aws:iam::aws:policy/AmazonRDSFullAccess",
#     "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator",
#     "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
#   ]

#   env_vars = {
#     # DB_PASSWORD = var.db_password
#   }
# }