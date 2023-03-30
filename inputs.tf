variable "ses_arn" {
  type        = string
  description = "The ARN of the SES service to use to send emails."
}
variable "email_subject" {
  type        = string
  description = "The Email Subject"
  default     = "AWS IAM - Credential Security."
}
variable "email_charset" {
  type        = string
  description = "The Email Charset."
  default     = "UTF-8"
}
variable "sender_email" {
  type        = string
  description = "The Email Sender that will appear on the emails."
}
variable "dryrun" {
  type        = bool
  description = "DRYRUN, ensures that no keys are deactivated and no email are sent. Set to false to deactivate keys."
  default     = true
}
variable "awsregion" {
  type        = string
  description = "The default AWS Region to use in the lambda."
  default     = "eu-west-1"
}
variable "credential_age_limit" {
  type        = string
  description = "Age limit of the credentials in Days."
  default     = "90"
}
variable "advanced_notification_days" {
  type        = string
  description = "Notification period before the Credential is nearing age limit and then it's deactivated, in Days."
  default     = "15"
}
variable "admin_email" {
  type        = string
  description = "The Administrators Email Address."
}
variable "iam_to_exclude" {
  type        = string
  description = "The IAM users to exclude from the deactivation."
  default     = "\"example\",\"example\""
}
variable "schedule" {
  type        = string
  description = "The cron schedule expression on when to run this lambda"
  default     = "cron(00 11 * * ? *)"
}
variable "lambda_timeout" {
  type        = string
  description = "The duration for the lambda to run"
  default     = "30"
}