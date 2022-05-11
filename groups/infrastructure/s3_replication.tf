resource "aws_s3_bucket_policy" "allow_access_from_heritage_staging" {
  for_each = toset(local.db_names)

  bucket = module.heritage_staging_chips_backup[each.value].s3_bucket_id
  policy = data.aws_iam_policy_document.allow_access_from_heritage_staging[each.value].json
}

data "aws_iam_policy_document" "allow_access_from_heritage_staging" {
  for_each = toset(local.db_names)

  statement {
    principals {
      type        = "AWS"
      identifiers = [local.account_ids["heritage-staging"]]
    }

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]

    resources = [
      "${module.heritage_staging_chips_backup[each.value].s3_bucket_arn}/*"
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [local.account_ids["heritage-staging"]]
    }

    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]

    resources = [
      module.heritage_staging_chips_backup[each.value].s3_bucket_arn
    ]
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_heritage_live" {
  for_each = toset(local.db_names)

  bucket = module.heritage_live_chips_backup[each.value].s3_bucket_id
  policy = data.aws_iam_policy_document.allow_access_from_heritage_live[each.value].json
}

data "aws_iam_policy_document" "allow_access_from_heritage_live" {
  for_each = toset(local.db_names)

  statement {
    principals {
      type        = "AWS"
      identifiers = [local.account_ids["heritage-live"]]
    }

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
    ]

    resources = [
      "${module.heritage_live_chips_backup[each.value].s3_bucket_arn}/*"
    ]
  }

  statement {
    principals {
      type        = "AWS"
      identifiers = [local.account_ids["heritage-live"]]
    }

    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]

    resources = [
      module.heritage_live_chips_backup[each.value].s3_bucket_arn
    ]
  }
}
