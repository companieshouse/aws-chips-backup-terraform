# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids  = data.vault_generic_secret.account_ids.data
  security_s3  = data.vault_generic_secret.security_s3.data
  security_kms = data.vault_generic_secret.security_kms.data

  s3_chips_backup_key      = module.kms["s3chipsbackup"]
  chips_backup_kms_key_arn = local.s3_chips_backup_key.key_arn

  internal_fqdn = "${var.aws_account}.${var.aws_region}.ch.gov.uk"

  cloudtrail_prefix    = "cloudtrail-logs"
  vpc_flow_logs_prefix = "flow-logs"

  internal_fqdn = "${var.aws_account}.${var.private_domain}"

  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }

  kms_customer_master_keys = {
    hdevs3chipsbackup = {
      description                   = "S3 Chips backup key"
      deletion_window_in_days       = 30
      enable_key_rotation           = true
      is_enabled                    = true
      key_usage_foreign_account_ids = local.account_ids["heritage-development"]
    }
    hstgs3chipsbackup = {
      description                   = "S3 Chips backup key"
      deletion_window_in_days       = 30
      enable_key_rotation           = true
      is_enabled                    = true
      key_usage_foreign_account_ids = local.account_ids["heritage-staging"]
    }
    hlives3chipsbackup = {
      description                   = "S3 Chips backup key"
      deletion_window_in_days       = 30
      enable_key_rotation           = true
      is_enabled                    = true
      key_usage_foreign_account_ids = local.account_ids["heritage-live"]
    }
  }
}
