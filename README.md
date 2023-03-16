## Created By
KO Technologies

## Information
The aws-iam-advisor will iterate through the IAM users and check their AWS access key age.\
The following will apply if the IAM user is in the email address format.\
If the key is over the age limit and email notification will be sent to the users email address.\
If the key remains in the IAM users profile for more than the age limit + grace period, the key becomes inactive.\
The following will apply if the IAM user is not in the email address format.\
The adminstrator will recieve and email for the IAM users access keys.

## Testing
Application tested with terraform 1.3.7.
Runtime tested with aws-iam-advisor deployed in the same region as SES in sandbox, in the same AWS Account.
Runtime tested with aws-iam-advisor deployed in a different region than SES in sandbox, in the same AWS Account.

## Runtime
The aws-iam-advisor is built with the go 1.18 and is supplied inside the main.zip.\
The following information about this module is created via terraform-docs.
### Ensure that the dryrun is set to false so that the function works.


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
| <a name="input_access_key_age_grace_period"></a> [access\_key\_age\_grace\_period](#input\_access\_key\_age\_grace\_period) | Grace period after the AWS Access Key is over the age limit and then it's deactivated. | `string` | `"15"` | no |
| <a name="input_access_key_age_limit"></a> [access\_key\_age\_limit](#input\_access\_key\_age\_limit) | How old can the AWS Access Key be before the email notice is issued. | `string` | `"90"` | no |
| <a name="input_admin_email"></a> [admin\_email](#input\_admin\_email) | The Administrators Email Address. | `string` | n/a | yes |
| <a name="input_awsregion"></a> [awsregion](#input\_awsregion) | The default AWS Region to use in the lambda. | `string` | `"eu-west-1"` | no |
| <a name="input_dryrun"></a> [dryrun](#input\_dryrun) | DRYRUN, ensures that no keys are deactivated and no email are sent. Set to false to deactivate keys. | `bool` | `true` | no |
| <a name="input_email_charset"></a> [email\_charset](#input\_email\_charset) | The Email Charset. | `string` | `"UTF-8"` | no |
| <a name="input_email_subject"></a> [email\_subject](#input\_email\_subject) | The Email Subject | `string` | `"AWS IAM - Access Key Security."` | no |
| <a name="input_iam_to_exclue"></a> [iam\_to\_exclue](#input\_iam\_to\_exclue) | The IAM users to exclude from the deactivation. | `string` | `"\"example\",\"example\""` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | The duration for the lambda to run | `string` | `"30"` | no |
| <a name="input_number_of_iam_users"></a> [number\_of\_iam\_users](#input\_number\_of\_iam\_users) | An estimate of IAM users to check. (This is required until the paging is implemented.). | `string` | `"100"` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | The cron schedule expression on when to run this lambda | `string` | `"cron(00 11 * * ? *)"` | no |
| <a name="input_send_cc_email_admin"></a> [send\_cc\_email\_admin](#input\_send\_cc\_email\_admin) | Send a copy to the admin. If the IAM user isn't an email address, the admin is notified by default. | `bool` | `false` | no |
| <a name="input_sender_email"></a> [sender\_email](#input\_sender\_email) | The Email Sender that will appear on the emails. | `string` | n/a | yes |
| <a name="input_ses_arn"></a> [ses\_arn](#input\_ses\_arn) | The ARN of the SES service to use to send emails. | `string` | n/a | yes |

## Outputs

No outputs.

## Example
```hcl
module "aws_iam_advisor" {
  source       = "KOTechnologiesLtd/iam-advisor/aws"
  version      = "1.0.0"
  ses_arn      = "arn:aws:ses:eu-west-2:XXXXXXXXXXXXXX:identity/XXXX@XXXXXXX.co.uk"
  sender_email = "XXXX@XXXXXXX.co.uk"
  admin_email  = "XXXX@XXXXXXX.co.uk"
  dryrun       = "false"
}
```
