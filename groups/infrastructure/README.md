# chips-backup-terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudtrail"></a> [cloudtrail](#module\_cloudtrail) | git@github.com:companieshouse/terraform-modules//aws/cloudtrail?ref=tags/1.0.99 |  |
| <a name="module_config"></a> [config](#module\_config) | git@github.com:companieshouse/terraform-modules//aws/config?ref=tags/1.0.63 |  |
| <a name="module_heritage_live_chips_backup"></a> [heritage\_live\_chips\_backup](#module\_heritage\_live\_chips\_backup) | terraform-aws-modules/s3-bucket/aws | 2.11.1 |
| <a name="module_heritage_live_chips_backup_policy"></a> [heritage\_live\_chips\_backup\_policy](#module\_heritage\_live\_chips\_backup\_policy) | git@github.com:companieshouse/terraform-modules//aws/s3_cross_account_policy?ref=tags/1.0.137 |  |
| <a name="module_heritage_staging_chips_backup"></a> [heritage\_staging\_chips\_backup](#module\_heritage\_staging\_chips\_backup) | terraform-aws-modules/s3-bucket/aws | 2.11.1 |
| <a name="module_heritage_staging_chips_backup_policy"></a> [heritage\_staging\_chips\_backup\_policy](#module\_heritage\_staging\_chips\_backup\_policy) | git@github.com:companieshouse/terraform-modules//aws/s3_cross_account_policy?ref=tags/1.0.137 |  |
| <a name="module_kms"></a> [kms](#module\_kms) | git@github.com:companieshouse/terraform-modules//aws/kms?ref=tags/1.0.56 |  |

## Resources

| Name | Type |
|------|------|
| [aws_config_conformance_pack.pci_dss](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_conformance_pack) | resource |
| [aws_s3_bucket_policy.allow_access_from_heritage_live](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_policy.allow_access_from_heritage_staging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_ssm_document.session_manager_settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [vault_generic_secret.kms](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [aws_iam_policy_document.allow_access_from_heritage_live](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_access_from_heritage_staging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | The shorthand for the AWS account | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The AWS account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_config_primary_region"></a> [config\_primary\_region](#input\_config\_primary\_region) | AWS config has options to collect and apply both regional and global collection, this is used to ensure global objects are only collected in a single region to avoid duplication. | `bool` | `false` | no |
| <a name="input_kms_customer_master_keys"></a> [kms\_customer\_master\_keys](#input\_kms\_customer\_master\_keys) | Map of KMS customer master keys and key policies to be created | `map` | `{}` | no |
| <a name="input_private_domain"></a> [private\_domain](#input\_private\_domain) | The suffix for the private domain name to be used for route53 zones | `string` | `"aws.internal"` | no |
| <a name="input_region"></a> [region](#input\_region) | The shorthand for the AWS region | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->