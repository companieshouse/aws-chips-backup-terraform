
resource "vault_generic_secret" "kms" {
  path = "aws-accounts/${var.aws_account}/kms"

  data_json = <<EOT
{
  "chipsbackup-kms-key-arn": "${module.kms["chipsbackup"].key_arn}"
}
EOT
}
