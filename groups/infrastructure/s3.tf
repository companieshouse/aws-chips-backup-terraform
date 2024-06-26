###################################
# Heritage-staging resources 
###################################
module "heritage_staging_chips_backup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.0.1"

  for_each = toset(local.db_names)

  bucket = "hstg-${each.value}-backup-${var.aws_account}-${var.aws_region}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id                                     = "VersionsManagement"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 7

      noncurrent_version_transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        }
      ]

      noncurrent_version_expiration = {
        days = 60
      }
    }
  ]

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
  source = "git@github.com:companieshouse/terraform-modules//aws/s3_cross_account_policy?ref=tags/1.0.267"

  for_each = toset(local.db_names)

  bucket_name   = module.heritage_staging_chips_backup[each.value].s3_bucket_id
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

  custom_statements = [
    {
      sid    = "ReplicationPermissions"
      effect = "Allow"

      principals = [{
        type        = "AWS"
        identifiers = [local.account_ids["heritage-staging"]]
      }]

      actions = [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
      ]

      resources = [
        "arn:aws:s3:::${module.heritage_staging_chips_backup[each.value].s3_bucket_id}/*",
      ]
    },
    {
      sid    = "VersionPermissions"
      effect = "Allow"

      principals = [{
        type        = "AWS"
        identifiers = [local.account_ids["heritage-staging"]]
      }]

      actions = [
        "s3:List*",
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning"
      ]

      resources = [
        "arn:aws:s3:::${module.heritage_staging_chips_backup[each.value].s3_bucket_id}"
      ]
    },
    {
      sid    = "DenyEverythingDeleteVersion"
      effect = "Deny"

      principals = [{
        type        = "*"
        identifiers = ["*"]
      }]

      actions = [
        "s3:DeleteObjectVersion"
      ]

      resources = [
        "arn:aws:s3:::${module.heritage_staging_chips_backup[each.value].s3_bucket_id}",
        "arn:aws:s3:::${module.heritage_staging_chips_backup[each.value].s3_bucket_id}/*",
      ]
    }
  ]

  // Depends on to avoid issues with conflicting operations adding bucket policy and public bock resources
  depends_on = [module.heritage_staging_chips_backup]
}

###################################
# Heritage-live resources 
###################################
module "heritage_live_chips_backup" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.0.1"

  for_each = toset(local.db_names)

  bucket = "hlive-${each.value}-backup-${var.aws_account}-${var.aws_region}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  lifecycle_rule = [
    {
      id                                     = "VersionsManagement"
      enabled                                = true
      abort_incomplete_multipart_upload_days = 7

      noncurrent_version_transition = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        }
      ]

      noncurrent_version_expiration = {
        days = 60
      }
    }
  ]

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
  source = "git@github.com:companieshouse/terraform-modules//aws/s3_cross_account_policy?ref=tags/1.0.267"

  for_each = toset(local.db_names)

  bucket_name   = module.heritage_live_chips_backup[each.value].s3_bucket_id
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


  custom_statements = [
    {
      sid    = "ReplicationPermissions"
      effect = "Allow"

      principals = [{
        type        = "AWS"
        identifiers = [local.account_ids["heritage-live"]]
      }]

      actions = [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
      ]

      resources = [
        "arn:aws:s3:::${module.heritage_live_chips_backup[each.value].s3_bucket_id}/*"
      ]
    },
    {
      sid    = "VersionPermissions"
      effect = "Allow"

      principals = [{
        type        = "AWS"
        identifiers = [local.account_ids["heritage-live"]]
      }]

      actions = [
        "s3:List*",
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning"
      ]

      resources = [
        "arn:aws:s3:::${module.heritage_live_chips_backup[each.value].s3_bucket_id}"
      ]
    },
    {
      sid    = "DenyEverythingDeleteVersion"
      effect = "Deny"

      principals = [{
        type        = "*"
        identifiers = ["*"]
      }]

      actions = [
        "s3:DeleteObjectVersion"
      ]

      resources = [
        "arn:aws:s3:::${module.heritage_live_chips_backup[each.value].s3_bucket_id}",
        "arn:aws:s3:::${module.heritage_live_chips_backup[each.value].s3_bucket_id}/*",
      ]
    }
  ]

  // Depends on to avoid issues with conflicting operations adding bucket policy and public bock resources
  depends_on = [module.heritage_live_chips_backup]
}
