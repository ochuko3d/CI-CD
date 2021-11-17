data "aws_ssm_parameter" "dbpassword" {
  name            = "production.nordcloud.ghost"
  with_decryption = true
}