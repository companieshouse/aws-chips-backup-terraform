# ------------------------------------------------------------------------------
# Providers
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.13.0, < 0.14"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0.3, < 4.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 2.0.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

provider "vault" {
  auth_login {
    path = "auth/userpass/login/${var.vault_username}"
    parameters = {
      password = var.vault_password
    }
  }
}

####################################################################################################
## IAM Password Policy
####################################################################################################

module "iam_password_policy" {
  source = "git@github.com:companieshouse/terraform-modules//aws/iam_password_policy?ref=tags/1.0.247"
}

####################################################################################################
## CloudTrail CIS alerting
## Configures an SNS Topic and a number of metric filters and alarms to alert on specific changes.
####################################################################################################

module "cloudtrail_cis_alerting" {
  source = "git@github.com:companieshouse/terraform-modules//aws/cloudtrail_cis_alerting?ref=tags/1.0.257"

  aws_profile    = "${var.aws_account}-${var.aws_region}"
  account        = var.account
  region         = var.region
  log_group_name = local.cloudwatch_log_group_for_cloudtrail
  tags           = local.default_tags

  depends_on = [module.cloudtrail]
}
