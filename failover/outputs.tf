output "production_name" {
  value = "${aws_route53_record.production.name}"
}

output "production_fqdn" {
  value = "${aws_route53_record.production.fqdn}"
}

output "fallback_name" {
  value = "${aws_route53_record.fallback.name}"
}

output "fallback_fqdn" {
  value = "${aws_route53_record.fallback.fqdn}"
}

output "failover_name" {
  value = "${aws_route53_record.failover_production.name}"
}

output "failover_fqdn" {
  value = "${aws_route53_record.failover_production.fqdn}"
}
