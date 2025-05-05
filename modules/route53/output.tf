output "record_fqdn" {
  description = "Fully qualified domain name of the record"
  value       = aws_route53_record.this.fqdn
}

output "zone_id" {
  description = "Hosted zone ID"
  value       = data.aws_route53_zone.this.zone_id
}
