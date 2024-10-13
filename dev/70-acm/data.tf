data "aws_route53_zone" "zone_info" {
  name = var.zone_name
}