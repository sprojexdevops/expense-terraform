resource "aws_acm_certificate" "expense_https_cert" {
  domain_name       = "*.${var.zone_name}"
  validation_method = "DNS"

  tags = merge(
    var.common_tags,
    {
      Name = local.resource_name #expense-dev
    }
  )

}

resource "aws_route53_record" "cert_records" {
  for_each = {
    for dvo in aws_acm_certificate.expense_https_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = local.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.expense_https_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_records : record.fqdn]
}