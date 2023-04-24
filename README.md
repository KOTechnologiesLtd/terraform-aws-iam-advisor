## Created By
KO Technologies
https://www.kotechnologies.co.uk

## Information
The aws-iam-advisor will iterate through the IAM users and check their AWS IAM Credentials.\
The version 2 release changes the mechanism by which the Access Key information is obtained. V1 uses the aws api,\
whilst v2 now uses the credentials report for a more informative and secure experience.\
<u>Credentials reports can only be generated every 4 hours</u>, so don't schedule this function run any sooner.\
The version 2 release also provides the capability to inform users on password expiry and signing certificate deactivation.\
The policy for the lambda function has also been tightened.

## How it works
The Lambda function is trigerred via cloudwatch cron event.
The lambda function will generate a credentials report and iterate the information.
Should an IAM credential show an expiring set of data, the user will be notified of their IAM health.
### IAM with email format
The following will apply if the IAM user is in the email address format. xxx@domain.com\
If the any of the IAM credentials for a given IAM is approaching the age limit an email notification will be sent to the <u>users email address</u>.
### IAM without email format
The following will apply if the IAM user is <u>not</u> in the email address format.\
If the any of the IAM credentials for a given IAM is approaching the age limit an email notification will be sent to the <u>administrators email address</u>.

## Testing
Application tested with terraform 1.3.7.
Runtime tested with aws-iam-advisor deployed in the same region as SES in sandbox, in the same AWS Account.
Runtime tested with aws-iam-advisor deployed in a different region than SES in sandbox, in the same AWS Account.

## Runtime
The aws-iam-advisor is built with the go 1.18 and is supplied inside the main.zip.\
The following information about this module is created via terraform-docs.
### Ensure that the dryrun is set to false so that the function works.

## Example Terraform
```hcl
module "aws_iam_advisor" {
  source       = "KOTechnologiesLtd/iam-advisor/aws"
  version      = "2.0.1"
  ses_arn      = "arn:aws:ses:eu-west-2:XXXXXXXXXXXXXX:identity/XXXX@XXXXXXX.co.uk"
  sender_email = "XXXX@XXXXXXX.co.uk"
  admin_email  = "XXXX@XXXXXXX.co.uk"
  dryrun       = "false"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_lambda_permission.cw_trigger_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [template_file.awsIamAdvisorPolicy](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | The Administrators Email Address. | `string` | n/a | yes |
| <a name="input_advanced_notification_days"></a> [advanced\_notification\_days](#input\_advanced\_notification\_days) | Notification period before the Credential is nearing age limit and then it's deactivated, in Days. | `string` | `"15"` | no |
| <a name="input_awsregion"></a> [awsregion](#input\_awsregion) | The default AWS Region to use in the lambda. | `string` | `"eu-west-1"` | no |
| <a name="input_credential_age_limit"></a> [credential\_age\_limit](#input\_credential\_age\_limit) | Age limit of the credentials in Days. | `string` | `"90"` | no |
| <a name="input_dryrun"></a> [dryrun](#input\_dryrun) | DRYRUN, ensures that no keys are deactivated and no email are sent. Set to false to deactivate keys. | `bool` | `true` | no |
| <a name="input_email_charset"></a> [email\_charset](#input\_email\_charset) | The Email Charset. | `string` | `"UTF-8"` | no |
| <a name="input_email_subject"></a> [email\_subject](#input\_email\_subject) | The Email Subject | `string` | `"AWS IAM - Credential Security."` | no |
| <a name="input_iam_to_exclude"></a> [iam\_to\_exclude](#input\_iam\_to\_exclude) | The IAM users to exclude from the deactivation. | `string` | `"\"example\",\"example\""` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | The duration for the lambda to run | `string` | `"30"` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | The cron schedule expression on when to run this lambda | `string` | `"cron(00 11 * * ? *)"` | no |
| <a name="input_sender_email"></a> [sender\_email](#input\_sender\_email) | The Email Sender that will appear on the emails. | `string` | n/a | yes |
| <a name="input_ses_arn"></a> [ses\_arn](#input\_ses\_arn) | The ARN of the SES service to use to send emails. | `string` | n/a | yes |

## Outputs

No outputs.


## Email Format

| Colour | Description |
|------|---------|
| GREEN | Credentials meet the requirements. |
| ORANGE | Credentials will soon be deactivated. |
| RED | Credentials have been deactivated. |

Example of the email report.

<html><body><h1>AWS IAM Advisor</h1><h2><u>Some of your credentials are due to expire. Ensure they are rotated before they are deactivated.</u></h2><table><tr><th>User</th><th>Credential</th><th>Limit(Days)</th><th>Age(Days)</th><th>Expiry - Days Remaining</th></tr><tr><td>user@domain.co.uk</td><td>AWS Console Password - (MFA Enabled: false)</td><td>90</td><td>75.754487</td><td style="background-color:orange;color:white;">65.245513</td></tr><tr><td>user@domain.co.uk</td><td>AWS Access Key 1</td><td>90</td><td>313.915610</td><td style="background-color:red;color:white;">-223.915610 deactivated</td></tr><tr><td>user@domain.co.uk</td><td>AWS Access Key 2</td><td>90</td><td>46.842708</td><td style="background-color:green;color:white;">43.157292</td></tr><tr><td>user@domain.co.uk</td><td>AWS Cert 1</td><td>90</td><td>76.805116</td><td style="background-color:orange;color:white;">64.194884</td></tr><tr><td>user@domain.co.uk</td><td>AWS Cert 2</td><td>90</td><td>25.805243</td><td style="background-color:green;color:white;">64.194757</td></tr></table></body></html><p></p>Created by KO Technologies an AWS Consulting Partner - <a href="https://www.kotechnologies.co.uk">KO Technologies<p></p></html>
