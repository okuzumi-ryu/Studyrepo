#Create ACM_Certificate Manager
resource "aws_acm_certificate" "terra" {
  domain_name       = var.SSL_domain
  validation_method = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#Set own DNS data
data "aws_route53_zone" "terra" {
  name         = var.Route53_zone_name
  private_zone = false
}

#Set Route53_record with ACM
resource "aws_route53_record" "terra" {
  for_each = {
    for dvo in aws_acm_certificate.terra.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.terra.zone_id
}

resource "aws_acm_certificate_validation" "terra" {
  certificate_arn         = aws_acm_certificate.terra.arn
  validation_record_fqdns = [for record in aws_route53_record.terra : record.fqdn]
}

