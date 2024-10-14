locals {
  resource_name  = "${var.project_name}-${var.environment}"
  https_cert_arn = data.aws_ssm_parameter.https_cert_arn.value
}