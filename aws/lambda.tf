################## Lambda 함수 생성 ##################
resource "aws_lambda_function" "lambda-exam" {
  function_name = "dasc-lambda-check-examid"
  handler       = "index.handler"
  runtime       = "python3.9"

  role = aws_iam_role.dasc-role-lambda-examid.arn

  filename = "pymysql_layer.zip"  # 이 파일은 Lambda 함수 코드가 포함된 zip 파일입니다.

  source_code_hash = filebase64sha256("pymysql_layer.zip")
}

################## Lambda 역할 설정 ##################
resource "aws_iam_role" "dasc-role-lambda-examid" {
  name = "dasc-role-lambda-examid"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dasc-role-lambda-examid" {
  role       = aws_iam_role.dasc-role-lambda-examid.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
################## AmazonEC2FullAccess 정책 부여 ##################
resource "aws_iam_role_policy_attachment" "lambda_ec2_fullaccess_attachment" {
  role       = aws_iam_role.dasc-role-lambda-examid.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
################## AmazonRDSFullAccess 정책 부여 ##################
resource "aws_iam_role_policy_attachment" "lambda_rds_fullaccess_attachment" {
  role       = aws_iam_role.dasc-role-lambda-examid.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
################## AmazonAPI 정책 부여 ##################
resource "aws_iam_role_policy_attachment" "lambda_api_admin_attachment" {
  role       = aws_iam_role.dasc-role-lambda-examid.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayAdministrator"
}
resource "aws_iam_role_policy_attachment" "lambda_api_invoke_attachment" {
  role       = aws_iam_role.dasc-role-lambda-examid.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

#### VPC 내에 배치 필요