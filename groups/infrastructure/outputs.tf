resource "vault_generic_secret" "kms" {
  path = "aws-accounts/${var.aws_account}/kms"

  data_json = jsonencode({
    hstg-chipsbackup-kms-key-arn  = module.kms["hstgs3chipsbackup"].key_arn
    hlive-chipsbackup-kms-key-arn = module.kms["hlives3chipsbackup"].key_arn
  })
}

