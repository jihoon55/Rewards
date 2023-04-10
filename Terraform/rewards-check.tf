resource "aws_iam_role" "rewards_check_lambda_role" {
  name = "rewards_chceck"

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

resource "aws_iam_policy" "rewards_check_lambda_policy" {
  name        = "rewards_chceck_lambda_policy"
  
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
        Resource = "arn:aws:dynamodb:ap-northeast-2:*:table/Rewards"
      },
    ]
  })
}

resource "aws_iam_policy" "rewards_check_logs_policy" {
  name = "rewards_check_logs_policy"

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

resource "aws_lambda_function" "rewards_check_lambda" {
  filename      = "./rewards-check.zip"
  function_name = "rewards_check"
  role          = aws_iam_role.rewards_check_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  environment {
    variables = {
      TABLE_NAME = "Rewards"
    }
  }
}

resource "aws_lambda_permission" "my_permission2" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rewards_check_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.admin_api.execution_arn}/*"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment2" {
  policy_arn = aws_iam_policy.rewards_check_lambda_policy.arn
  role       = aws_iam_role.rewards_check_lambda_role.name 
}

  resource "aws_iam_role_policy_attachment" "lambda_logs_policy_attachment2" {
  policy_arn = aws_iam_policy.rewards_check_logs_policy.arn
  role       = aws_iam_role.rewards_check_lambda_role.name
}

