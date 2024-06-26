# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  account_ids  = data.vault_generic_secret.account_ids.data
  security_s3  = data.vault_generic_secret.security_s3.data
  security_kms = data.vault_generic_secret.security_kms.data

  cloudtrail_prefix    = "cloudtrail-logs"
  vpc_flow_logs_prefix = "flow-logs"

  cloudwatch_log_group_for_cloudtrail = "/cloudtrail/${var.aws_account}-${var.region}"

  internal_fqdn = "${var.aws_account}.${var.private_domain}"

  default_tags = {
    Terraform = "true"
    Project   = var.account
    Region    = var.aws_region
  }

  db_names = [
    "chips-oltp",
    "chips-rep",
    "staffware"
  ]

  kms_customer_master_keys = {
    hstgs3chipsbackup = {
      description                   = "S3 Chips backup key"
      deletion_window_in_days       = 30
      enable_key_rotation           = true
      is_enabled                    = true
      key_usage_foreign_account_ids = [local.account_ids["heritage-staging"]]
    },
    hlives3chipsbackup = {
      description                   = "S3 Chips backup key"
      deletion_window_in_days       = 30
      enable_key_rotation           = true
      is_enabled                    = true
      key_usage_foreign_account_ids = [local.account_ids["heritage-live"]]
    }
  }
}
