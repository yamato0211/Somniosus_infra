resource "aws_route53_zone" "public" {
  name = var.my_domain

  tags = {
    Name = "${local.name_prefix}-route53-zone"
  }
}

resource "aws_acm_certificate" "public" {
  domain_name               = aws_route53_zone.public.name
  subject_alternative_names = ["*.${aws_route53_zone.public.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${local.name_prefix}-acm"
  }
}

resource "aws_route53_record" "public_dns_verify" {
  for_each = {
    for dvo in aws_acm_certificate.public.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.public.id
}

resource "aws_acm_certificate_validation" "public" {
  certificate_arn         = aws_acm_certificate.public.arn
  validation_record_fqdns = [for record in aws_route53_record.public_dns_verify : record.fqdn]
}

resource "aws_route53_record" "alb_record" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "ingress.${var.my_domain}"
  type    = "CNAME"
  ttl     = "300"
  records = [var.alb_endpoint]
}


output "name_servers" {
  description = "A list of name servers in associated (or default) delegation set."
  value       = aws_route53_zone.public.name_servers
}