resource "aws_ssm_document" "session_manager_settings" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"
  content         = <<DOC
{
  "schemaVersion": "1.0",
  "description": "Document to hold regional settings for Session Manager",
  "sessionType": "Standard_Stream",
  "parameters": {
    "linuxcmd": {
      "type": "String",
      "default": "echo Connected to $(hostname)",
      "description": "The command to run on connection."
    },
    "windowscmd": {
      "type": "String",
      "default": "Write-Host Connected to $([System.Net.Dns]::GetHostName())",
      "description": "The command to run on connection."
    }
  },
  "inputs": {
    "s3BucketName": "${local.security_s3["session-manager-bucket-name"]}",
    "s3KeyPrefix": "${var.aws_account}-${var.aws_region}",
    "s3EncryptionEnabled": "true",
    "cloudWatchLogGroupName": "",
    "cloudWatchEncryptionEnabled": "false",
    "idleSessionTimeout": "5",
    "kmsKeyId": "${local.security_kms["session-manager-kms-key-arn"]}",
    "shellProfile": {
      "windows": "{{ windowscmd }}",
      "linux": "{{ linuxcmd }}"
    }
  }
}
DOC

  tags = merge(
    local.default_tags,
    {
      "Account"     = var.aws_account,
      "ServiceTeam" = "Network"
    }
  )
}
