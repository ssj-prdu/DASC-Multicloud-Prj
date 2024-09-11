# ################## Lambda 함수 생성 ##################
# resource "aws_lambda_function" "lambda-exam" {
#   function_name = "${var.prefix}-lambda-check-examid"
#   handler       = "index.handler"
#   runtime       = var.runtime

#   role = aws_iam_role.dasc-role-lambda-examid.arn

#   filename = var.filename # 이 파일은 Lambda 함수 코드가 포함된 zip 파일입니다.

#   source_code_hash = filebase64sha256(var.filename)

#   vpc_config {
#     subnet_ids         = var.subnet_ids
#     security_group_ids = var.security_group_ids # 적절한 보안 그룹 ID 사용
#   }

#   environment {
#     variables = var.env_vars
#   }
# }

# ################## Lambda 역할 설정 ##################
# resource "aws_iam_role" "dasc-role-lambda-examid" {
#   name = "${var.prefix}-role-lambda-examid"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "attachments" {

#   count = length(var.policy_arns)

#   role       = aws_iam_role.dasc-role-lambda-examid.name
#   policy_arn = var.policy_arns[count.index]
# }


# #### VPC 내에 배치 필요
