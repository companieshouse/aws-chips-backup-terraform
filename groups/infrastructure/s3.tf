###################################
# Heritage-staging resources 
###################################
module "heritage_staging_chips_backup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"

  for_each = toset(local.db_names)

  bucket = "hstg-${each.value}-backup-${var.aws_account}-${var.aws_region}"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  # lifecycle_rule = [
  #   #Long term cold backup, we should have data lifecycle/tiering
  # ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms["hstgs3chipsbackup"].key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

module "heritage_staging_chips_backup_policy" {
  source = "git@github.com:companieshouse/terraform-modules//aws/s3_cross_account_policy?ref=tags/1.0.115"

  bucket_name   = module.heritage_staging_chips_backup.s3_bucket_id
  attach_policy = true
  bucket_read_accounts = [
    local.account_ids["heritage-staging"],
  ]
  bucket_write_accounts_no_acl = [
    local.account_ids["heritage-staging"],
  ]
  bucket_delete_accounts = [
    local.account_ids["heritage-staging"],
  ]
  s3_bucket_ownership_control = "BucketOwnerEnforced"

  // Depends on to avoid issues with conflicting operations adding bucket policy and public bock resources
  depends_on = [module.heritage_staging_chips_backup]
}


###################################
# Heritage-live resources 
###################################
module "heritage_live_chips_backup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"

  for_each = toset(local.db_names)

  bucket = "hlive-${each.value}-backup-${var.aws_account}-${var.aws_region}"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  # lifecycle_rule = [
  #   #Long term cold backup, we should have data lifecycle/tiering
  # ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.kms["hlives3chipsbackup"].key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

module "heritage_live_chips_backup_policy" {
  source = "git@github.com:companieshouse/terraform-modules//aws/s3_cross_account_policy?ref=tags/1.0.115"

  bucket_name   = module.heritage_live_chips_backup.s3_bucket_id
  attach_policy = true
  bucket_read_accounts = [
    local.account_ids["heritage-live"],
  ]
  bucket_write_accounts_no_acl = [
    local.account_ids["heritage-live"],
  ]
  bucket_delete_accounts = [
    local.account_ids["heritage-live"],
  ]
  s3_bucket_ownership_control = "BucketOwnerEnforced"

  // Depends on to avoid issues with conflicting operations adding bucket policy and public bock resources
  depends_on = [module.heritage_live_chips_backup]
}
