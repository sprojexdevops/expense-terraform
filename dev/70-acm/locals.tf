locals {
  resource_name = "${var.project_name}-${var.environment}"
  zone_id       = data.aws_route53_zone.zone_info.zone_id
}