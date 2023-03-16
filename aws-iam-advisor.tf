
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
  handler                = "main"
  runtime                = "go1.x"
  memory_size            = "128"
  attach_policy_json     = true
  policy_json            = data.template_file.awsIamAdvisorPolicy.rendered
  publish                = true
  create_package         = false
  local_existing_package = "${path.module}/main.zip"
  attach_network_policy  = true
  timeout                = var.lambda_timeout

  environment_variables = {
    "EMAIL_SUBJECT"                         = var.email_subject,
    "EMAIL_CHARSET"                         = var.email_charset,
    "SENDER_EMAIL"                          = var.sender_email,
    "DRYRUN"                                = var.dryrun,
    "AWSREGION"                             = var.awsregion,
    "ACCESS_KEY_AGE_LIMIT_DAYS"             = var.access_key_age_limit,
    "ACCESS_KEY_INACTIVE_GRACE_PERIOD_DAYS" = var.access_key_age_grace_period,
    "IAM_USER_COUNT"                        = var.number_of_iam_users,
    "ADMIN_EMAIL_AS_CC"                     = var.send_cc_email_admin,
    "ADMIN_EMAIL"                           = var.admin_email,
    "SES_ARN"                               = var.ses_arn,
    "IAM_USER_EXCLUDE_CSV"                  = var.iam_to_exclue
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
