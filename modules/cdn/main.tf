resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}


resource "aws_cloudfront_origin_access_control" "oac" {
  name        = "${var.oac_name}-${random_string.suffix.result}"  
  description = var.oac_description

  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                   = "sigv4"
}



resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.origin_id

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled        = var.enabled
  is_ipv6_enabled = var.is_ipv6_enabled

  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = var.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy

    forwarded_values {
      query_string = var.query_string
      cookies {
        forward = var.cookie_forwarding
      }
    }
  }

  default_root_object = var.default_root_object

  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
    }
  }

viewer_certificate {
  acm_certificate_arn            = var.acm_certificate_arn != "" ? var.acm_certificate_arn : null
  ssl_support_method             = var.acm_certificate_arn != "" ? "sni-only" : null
  cloudfront_default_certificate = var.acm_certificate_arn == "" ? true : false
}

aliases = var.custom_domain_name != "" ? [var.custom_domain_name] : []





  price_class = var.price_class
}