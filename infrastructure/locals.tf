# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids  = data.vault_generic_secret.account_ids.data
  security_s3  = data.vault_generic_secret.security_s3.data
  security_kms = data.vault_generic_secret.security_kms.data

  s3_chips_backup_key      = module.kms["s3chipsbackup"]
  chips_backup_kms_key_arn = local.s3_chips_backup_key.key_arn

  internal_fqdn = format("%s.%s.${var.private_domain}", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  s3bucket_account_allowlist = [
    local.account_ids["heritage-development"],
    local.account_ids["heritage-live"],
    local.account_ids["heritage-staging"],
  ]

  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }
}
