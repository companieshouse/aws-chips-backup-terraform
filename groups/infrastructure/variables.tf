# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "account" {
  type        = string
  description = "The shorthand for the AWS account"
}

variable "aws_account" {
  type        = string
  description = "The AWS account in which resources will be administered"
}

variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "region" {
  type        = string
  description = "The shorthand for the AWS region"
}

variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault"
}

variable "kms_customer_master_keys" {
  description = "Map of KMS customer master keys and key policies to be created"
  default     = {}
}

variable "config_primary_region" {
  description = "AWS config has options to collect and apply both regional and global collection, this is used to ensure global objects are only collected in a single region to avoid duplication."
  type        = bool
  default     = false
}
