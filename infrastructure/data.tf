# ------------------------------------------------------------------------------
# Data
# ------------------------------------------------------------------------------
data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "security_s3" {
  path = "aws-accounts/security/s3"
}

data "vault_generic_secret" "security_kms" {
  path = "aws-accounts/security/kms"
}

data "aws_subnet_ids" "attach" {
  vpc_id = module.vpc.vpc_id

  filter {
    name   = "tag:Name"
    values = ["sub-attach*"]
  }
}