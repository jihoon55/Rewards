resource "aws_apigatewayv2_api" "admin_api" {
  name          = "admin_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "products_api" {
  api_id           = aws_apigatewayv2_api.admin_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.product-adjustment_lambda.invoke_arn
}

resource "aws_apigatewayv2_integration" "rewards_api" {
  api_id           = aws_apigatewayv2_api.admin_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.rewards_check_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "products_api" {
  api_id    = aws_apigatewayv2_api.admin_api.id
  route_key = "PUT /product/{id}"

  target = "integrations/${aws_apigatewayv2_integration.products_api.id}"
}

resource "aws_apigatewayv2_route" "rewards_api" {
  api_id    = aws_apigatewayv2_api.admin_api.id
  route_key = "GET /rewards/{id}"

  target = "integrations/${aws_apigatewayv2_integration.rewards_api.id}"
}

resource "aws_apigatewayv2_stage" "admin_api" {
  api_id      = aws_apigatewayv2_api.admin_api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.admin_api.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
  depends_on = [aws_cloudwatch_log_group.admin_api]
}

resource "aws_cloudwatch_log_group" "admin_api" {
  name              = "/aws/api_gw/${aws_apigatewayv2_api.admin_api.name}"
  retention_in_days = 14
}

resource "aws_apigatewayv2_deployment" "admin_api" {
  api_id      = aws_apigatewayv2_api.admin_api.id

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.products_api),
      jsonencode(aws_apigatewayv2_route.products_api),
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_apigatewayv2_deployment" "admin_api2" {
  api_id      = aws_apigatewayv2_api.admin_api.id

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.rewards_api),
      jsonencode(aws_apigatewayv2_route.rewards_api),
    ])))
  }


  lifecycle {
    create_before_destroy = true
  }
}

