resource "aws_lambda_function" "attendance_lambda" {
  function_name = "Attendance_status"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.lambda_execution_role.arn

  filename = "/home/ekseh93/ekseh93_devops_03_Final-TeamC/attendance_status/index.zip"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "attendance_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "attendance_dynamodb_policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:GetItem",
        ]
        Effect = "Allow"
        Resource = "arn:aws:dynamodb:ap-northeast-2:*:table/Attendance"
      }
    ]
  })
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "admin-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "attendance_lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.attendance_lambda.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "attendance_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /attendance/{user_id}"
  target    = "integrations/${aws_apigatewayv2_integration.attendance_lambda_integration.id}"
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.attendance_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*/attendance/{user_id}"
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

resource "aws_apigatewayv2_deployment" "example" {
  api_id      = aws_apigatewayv2_api.http_api.id

  depends_on = [
    aws_apigatewayv2_route.attendance_route,
  ]
}

resource "aws_apigatewayv2_stage" "example" {
  api_id = aws_apigatewayv2_api.http_api.id
  name   = "admin"
  deployment_id = aws_apigatewayv2_deployment.example.id
  auto_deploy = true
}