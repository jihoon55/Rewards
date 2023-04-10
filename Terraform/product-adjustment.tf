resource "aws_iam_role" "product_adjust_lambda_role" {
  name = "product_adjust_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "product_adjust_lambda_policy" {
  name        = "product_adjust_lambda_policy"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:ap-northeast-2:*:table/Products"
      },
    ]
  })
}

resource "aws_iam_policy" "product_adjust_lambda_logs_policy" {
  name = "product_adjust_lambda_logs_policy"

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
        Resource = "arn:aws:logs:ap-northeast-2:*:log-group:/aws/lambda/*:*"

      }
    ]
  })
}

resource "aws_lambda_function" "product-adjustment_lambda" {
  filename      = "./product-adjustment.zip"
  function_name = "product-adjustment"
  role          = aws_iam_role.product_adjust_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  environment {
    variables = {
      TABLE_NAME = "Products"
    }
  }
}

resource "aws_lambda_permission" "product_adjust_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.product-adjustment_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.admin_api.execution_arn}/*"
}

resource "aws_iam_role_policy_attachment" "product_adjust_lambda_policy_attachment" {
  policy_arn = aws_iam_policy.product_adjust_lambda_policy.arn
  role       = aws_iam_role.product_adjust_lambda_role.name 
}

  resource "aws_iam_role_policy_attachment" "product_adjust_lambda_logs_policy_attachment" {
  policy_arn = aws_iam_policy.product_adjust_lambda_logs_policy.arn
  role       = aws_iam_role.product_adjust_lambda_role.name
}

