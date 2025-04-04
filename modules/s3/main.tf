data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_tag_name
  }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = var.index_document_suffix
  }

  error_document {
    key = var.error_document_key
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# Policy for IAM user access (s3:GetObject)
resource "aws_s3_bucket_policy" "iam_user_policy" {
  count  = var.policy_type == "iam_user" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowIAMUserGetObject",
        Effect    = "Allow",
        Principal = { AWS = var.iam_user_arn },
        Action    = ["s3:GetObject"],
        Resource  = ["arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*"]
      }
    ]
  })
}

# Policy for CloudFront access (s3:GetObject with condition)
resource "aws_s3_bucket_policy" "cloudfront_policy" {
  count  = var.policy_type == "cloudfront" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket

  depends_on = [aws_s3_bucket.s3_bucket]

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess",
        Effect    = "Allow",
        Principal = { Service = "cloudfront.amazonaws.com" },
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
          }
        }
      }
    ]
  })
}

# Policy for public access with additional IAM user permissions
resource "aws_s3_bucket_policy" "public_iam_policy" {
  count  = var.policy_type == "public_iam" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.bucket

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      // Public GetObject Access
      {
        Sid       = "AllowPublicGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*"
      },
      // IAM User Put, Delete, and List Access
      {
        Sid       = "AllowIAMUserPutDeleteList",
        Effect    = "Allow",
        Principal = { AWS = var.iam_user_arn },
        Action    = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource  = [
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*"
        ]
      }
    ]
  })
}