
data "template_file" "awsIamAdvisorPolicy" {
  template = file("${path.module}/policy/aws-iam-advisor.json")
  vars = {
    ses_arn = var.ses_arn
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2.0"

  function_name          = "aws-iam-advisor"
  description            = "AWS IAM Advisor"
  handler                = "bootstrap"
  runtime                = "provided.al2"
  memory_size            = "128"
  attach_policy_json     = true
  policy_json            = data.template_file.awsIamAdvisorPolicy.rendered
  publish                = true
  create_package         = false
  local_existing_package = "${path.module}/main.zip"
  attach_network_policy  = true
  timeout                = var.lambda_timeout

  environment_variables = {
    "DRYRUN"                                = var.dryrun,
    "EMAIL_SUBJECT"                         = var.email_subject,
    "EMAIL_CHARSET"                         = var.email_charset,
    "SENDER_EMAIL"                          = var.sender_email,
    "ADMIN_EMAIL"                           = var.admin_email,
    "AWSREGION"                             = var.awsregion,
    "CREDENTIAL_AGE_LIMIT"                  = var.credential_age_limit,
    "ADVANCED_NOTIFICATION_DAYS"            = var.advanced_notification_days,
    "SES_ARN"                               = var.ses_arn,
    "IAM_USER_EXCLUDE_CSV"                  = var.iam_to_exclude
  }
}

resource "aws_cloudwatch_event_rule" "default" {
  name                = "${module.lambda_function.lambda_function_name}-trigger"
  description         = "Trigger for aws-iam-advisor"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "default" {
  rule      = aws_cloudwatch_event_rule.default.name
  target_id = "${module.lambda_function.lambda_function_name}-id"
  arn       = module.lambda_function.lambda_function_arn
}

resource "aws_lambda_permission" "cw_trigger_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.default.arn
}
