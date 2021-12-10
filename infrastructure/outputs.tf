
resource "vault_generic_secret" "kms" {
  path = "aws-accounts/${var.aws_account}/kms"

  data_json = jsonencode({ for name, outputs in module.kms : name => outputs["key_arn"] })
}
