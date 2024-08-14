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
################## Method Response (POST) ##################
resource "aws_api_gateway_method_response" "post_method_response" {
  rest_api_id = aws_api_gateway_method.post_method.rest_api_id
  resource_id = aws_api_gateway_method.post_method.resource_id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

################## 메서드 설정 (OPTIONS) ##################
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.rest_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
################## Method Response (OPTIONS) ##################
resource "aws_api_gateway_method_response" "options_method_response" {
  rest_api_id = aws_api_gateway_method.options_method.rest_api_id
  resource_id = aws_api_gateway_method.options_method.resource_id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  response_models = {
    "application/json" = "Empty"
  }
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

################## Lambda Integration Response (POST) ##################
resource "aws_api_gateway_integration_response" "post_integration_response" {
  rest_api_id = aws_api_gateway_integration.lambda_integration.rest_api_id
  resource_id = aws_api_gateway_integration.lambda_integration.resource_id
  http_method = aws_api_gateway_integration.lambda_integration.http_method
  status_code = aws_api_gateway_method_response.post_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

################## Lambda Integration Response (OPTIONS) ##################
resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_integration.lambda_integration.rest_api_id
  resource_id = aws_api_gateway_integration.lambda_integration.resource_id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

################## API Gateway 배포 ##################
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_method.post_method,
    aws_api_gateway_method.options_method
  ]

  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "prod"  # 프로덕션 환경 배포
}
