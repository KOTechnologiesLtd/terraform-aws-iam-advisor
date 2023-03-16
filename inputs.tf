variable "ses_arn" {
  type        = string
  description = "The ARN of the SES service to use to send emails."
}
variable "email_subject" {
  type        = string
  description = "The Email Subject"
  default     = "AWS IAM - Access Key Security."
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
variable "access_key_age_limit" {
  type        = string
  description = "How old can the AWS Access Key be before the email notice is issued."
  default     = "90"
}
variable "access_key_age_grace_period" {
  type        = string
  description = "Grace period after the AWS Access Key is over the age limit and then it's deactivated."
  default     = "15"
}
variable "number_of_iam_users" {
  type        = string
  description = "An estimate of IAM users to check. (This is required until the paging is implemented.)."
  default     = "100"
}
variable "send_cc_email_admin" {
  type        = bool
  description = "Send a copy to the admin. If the IAM user isn't an email address, the admin is notified by default."
  default     = false
}
variable "admin_email" {
  type        = string
  description = "The Administrators Email Address."
}
variable "iam_to_exclue" {
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