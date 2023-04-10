provider "aws" {
  region = "ap-northeast-2"
}

locals {
  cognito_domain = "your-domain-prefix" # Replace with your desired domain prefix
}

resource "aws_cognito_user_pool" "user_authentication_pool" {
  name = "User authentication pool"

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "email"
    required                 = true
  }
}

resource "aws_cognito_user_pool_client" "user_authentication_client" {
  name         = "User authentication Client"
  user_pool_id = aws_cognito_user_pool.user_authentication_pool.id

  allowed_oauth_flows = [
    "implicit"
  ]

  allowed_oauth_scopes = [
    "openid",
  ]

    callback_urls = [
    "${aws_apigatewayv2_api.http_api.api_endpoint}/cognito/token"
  ]

  allowed_oauth_flows_user_pool_client = true

  supported_identity_providers         = [
    "COGNITO"
    ]
}

resource "aws_cognito_user_pool_domain" "user_domain" {
  domain       = local.cognito_domain
  user_pool_id = aws_cognito_user_pool.user_authentication_pool.id
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_authentication_pool.id
}

output "app_client_id" {
  value = aws_cognito_user_pool_client.user_authentication_client.id
}

resource "aws_lambda_function" "cognito-token" {
  function_name = "cognito-token"
  handler       = "index.handler"
  role          = aws_iam_role.lambda_exec_role.arn
  runtime       = "nodejs14.x"

  filename = "/home/ekseh93/devops_03_Final_TeamC/cognito/cognito_token.zip"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

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

resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "lambda_exec_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_apigatewayv2_api" "http_api" {
  name          = "cognito-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"

  connection_type      = "INTERNET"
  integration_method   = "POST"
  integration_uri       = aws_lambda_function.cognito-token.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "http_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /cognito/token"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"

  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cog-jwt.id

  depends_on = [
    aws_apigatewayv2_authorizer.cog-jwt
  ]
}

resource "aws_apigatewayv2_authorizer" "cog-jwt" {
  api_id          = aws_apigatewayv2_api.http_api.id
  authorizer_type = "JWT"
  name            = "cog-jwt"
  identity_sources = [
    "$request.querystring.access_token"
  ]

jwt_configuration {
  audience = [
    aws_cognito_user_pool_client.user_authentication_client.id
  ]
  issuer = "https://cognito-idp.ap-northeast-2.amazonaws.com/${aws_cognito_user_pool.user_authentication_pool.id}"
  }
}

output "api_endpoint" {
  value = aws_apigatewayv2_api.http_api.api_endpoint
}

resource "aws_apigatewayv2_deployment" "example" {
  api_id      = aws_apigatewayv2_api.http_api.id

  depends_on = [
    aws_apigatewayv2_route.http_route,
  ]
}


resource "aws_apigatewayv2_stage" "example" {
  api_id = aws_apigatewayv2_api.http_api.id
  name   = "default"
  deployment_id = aws_apigatewayv2_deployment.example.id
  auto_deploy = true
}