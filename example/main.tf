module "aws_iam_advisor" {
  source       = "KOTechnologiesLtd/iam-advisor/aws"
  version      = "1.0.2"
  ses_arn      = "arn:aws:ses:eu-west-2:XXXXXXXXXXXXXX:identity/XXXX@XXXXXXX.co.uk"
  sender_email = "XXXX@XXXXXXX.co.uk"
  admin_email  = "XXXX@XXXXXXX.co.uk"
  dryrun       = "false"
  iam_to_exclue = "\"example\",\"example\""
}