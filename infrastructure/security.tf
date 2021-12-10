module "config" {
  source = "git@github.com:companieshouse/terraform-modules//aws/config?ref=tags/1.0.63"

  name = "${var.account}-conf"

  config_s3_bucket_name   = local.security_s3["config-bucket-id"]
  config_s3_bucket_prefix = var.aws_account

  config_recorder_all_supported                 = true
  config_recorder_include_global_resource_types = var.config_primary_region
  create_delivery_channel                       = true
  is_recorder                                   = true
  is_aggregator                                 = false
  aggregator_account_id                         = local.account_ids["security"]
}

resource "aws_config_conformance_pack" "pci_dss" {
  name            = "Operational-Best-Practices-for-PCI-DSS"
  template_s3_uri = "s3://${local.security_s3["config-bucket-id"]}/conformance_packs/Operational-Best-Practices-for-PCI-DSS-3.2.1-6b61077d8d3b984d89499fcc7e286b69.yaml"

  input_parameter {
    parameter_name  = "AuthorizedVpcIds"
    parameter_value = [] #Comma separated list as string
  }

  depends_on = [module.config]
}

module "cloudtrail" {
  source = "git@github.com:companieshouse/terraform-modules//aws/cloudtrail?ref=tags/1.0.99"

  trail_name     = "ct-${var.aws_account}-${var.region}-001"
  s3_bucket_name = local.security_s3["cloudtrail-bucket-name"]
  s3_key_prefix  = local.cloudtrail_prefix

  kms_key = local.security_kms["cloudtrail-kms-key-arn"]

  event_selectors = [
    {
      read_write_type           = "All"
      include_management_events = true

      data_resource = [{
        type   = "AWS::S3::Object"
        values = ["arn:aws:s3:::"]
      }]
    }
  ]
}
