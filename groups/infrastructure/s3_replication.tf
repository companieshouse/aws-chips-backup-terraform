resource "aws_s3_bucket_policy" "allow_access_from_heritage_staging" {
  for_each = toset(local.db_names)
  
  bucket = module.heritage_staging_chips_backup[each.value].s3_bucket_id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
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
      "${module.heritage_staging_chips_backup[each.value].s3_bucket_arn}/*",
    ]
  }
}

{
   "Version":"2012-10-17",
   "Id":"",
   "Statement":[
      {
         "Sid":"Set permissions for objects",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::source-bucket-acct-ID:role/service-role/source-acct-IAM-role"
         },
         "Action":["s3:ReplicateObject", "s3:ReplicateDelete"],
         "Resource":"arn:aws:s3:::destination/*"
      },
      {
         "Sid":"Set permissions on bucket",
         "Effect":"Allow",
         "Principal":{
            "AWS":"arn:aws:iam::source-bucket-acct-ID:role/service-role/source-acct-IAM-role"
         },
         "Action":["s3:List*", "s3:GetBucketVersioning", "s3:PutBucketVersioning"],
         "Resource":"arn:aws:s3:::destination"
      }
   ]
}