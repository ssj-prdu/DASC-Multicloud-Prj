################## REST API 생성 ##################
resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "dasc-api-was"
  description = "REST API"

  endpoint_configuration {
  types = ["REGIONAL"]
  }
}

################## 리소스 경로 생성 ##################
resource "aws_api_gateway_resource" "rest_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "exam"  # /exam 경로를 생성
}

################## 메서드 설정 (POST) ##################
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_resource.id
  http_method   = "POST"
  authorization = "NONE"  # 인증 없이 허용
}
################## 메서드 설정 (OPTIONS) ##################
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
################## Lambda 통합 설정 ##################
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.rest_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda-exam.invoke_arn
}