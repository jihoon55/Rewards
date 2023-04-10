
resource "aws_ses_configuration_set" "email_set" {
  name = "manager-email-set"
}

resource "aws_ses_email_identity" "manager_email" {
  email = "rlawlgnswns@naver.com"
}
