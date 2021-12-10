module "chips_backup_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.11.1"

  bucket = "${local.chips_backup_bucket_name}.${var.aws_account}.${var.aws_region}"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  # lifecycle_rule = [
  #   #Long term cold backup, we need data lifecycle/tiering
  # ]

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = local.chips_backup_kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

module "chips_backup_bucket_policy" {
  source = "git@github.com:companieshouse/terraform-modules//aws/s3_cross_account_policy?ref=tags/1.0.99"

  bucket_name   = module.resources_bucket.s3_bucket_id
  attach_policy = true
  bucket_read_accounts = [
  ]
  bucket_write_accounts = [
    local.account_ids["heritage-development"],
    local.account_ids["heritage-staging"],
    local.account_ids["heritage-live"],
  ]
  bucket_delete_accounts = [
  ]

  // Depends on to avoid issues with conflicting operations adding bucket policy and public bock resources
  depends_on = [module.chips_backup_bucket]
}
