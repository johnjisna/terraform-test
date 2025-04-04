output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}

output "cdn_arn" {
  value = aws_cloudfront_distribution.cdn.arn
}