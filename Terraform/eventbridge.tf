resource "aws_cloudwatch_event_rule" "cron_check" {
  name        = "cron_check"
  schedule_expression = "cron(0 19 * * ? *)" 
  
}

resource "aws_cloudwatch_event_target" "cron_lambda" {
  rule      = aws_cloudwatch_event_rule.cron_check.name
  target_id = "check-stock-quantity"
  arn       = aws_lambda_function.cron_lambda.arn
}