variable "oac_name" {
  description = "Name for the Origin Access Control"
  default     = "S3-OAC"
}

variable "oac_description" {
  description = "Description for the Origin Access Control"
  default     = "Origin Access Control for CloudFront to access S3 bucket"
}

variable "bucket_regional_domain_name" {
  description = "Domain name of the S3 bucket"
}

variable "origin_id" {
  description = "Unique origin ID"
  default     = "S3-my-public-bucket"
}

variable "enabled" {
  description = "Enable the CloudFront distribution"
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Enable IPv6 for the distribution"
  default     = true
}

variable "allowed_methods" {
  description = "Allowed HTTP methods"
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "Cached HTTP methods"
  default     = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  description = "Protocol policy for viewers"
  default     = "redirect-to-https"
}

variable "query_string" {
  description = "Forward query strings"
  default     = false
}

variable "cookie_forwarding" {
  description = "Cookie forwarding policy"
  default     = "none"
}

variable "default_root_object" {
  description = "Default root object for the distribution"
  default     = "index.html"
}

variable "restriction_type" {
  description = "Geo restriction type"
  default     = "none"
}

variable "cloudfront_default_certificate" {
  description = "Use the default CloudFront SSL certificate"
  default     = true
}

variable "price_class" {
  description = "Price class for the distribution"
  default     = "PriceClass_100"
}


variable "custom_domain_name" {
  description = "Custom domain name for CloudFront distribution"
  default     = "null"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM SSL certificate for custom domain"
  default     = "null"
  type        = string
}