variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "default-tf-bucket-name"
}

variable "bucket_tag_name" {
  description = "The name tag for the S3 bucket"
  type        = string
  default     = "Default Bucket Tag"
}

variable "index_document_suffix" {
  description = "The suffix for the index document in the S3 bucket website configuration"
  type        = string
  default     = "index.html"
}

variable "error_document_key" {
  description = "The key for the error document in the S3 bucket website configuration"
  type        = string
  default     = "error.html"
}


variable "block_public_acls" {
  description = "Whether to block public ACLs"
  type        = bool
  default     = false
}

variable "block_public_policy" {
  description = "Whether to block public bucket policies"
  type        = bool
  default     = false
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs"
  type        = bool
  default     = false
}

variable "restrict_public_buckets" {
  description = "Whether to restrict public buckets"
  type        = bool
  default     = false
}

variable "cloudfront_distribution_id" {
  type        = string
  description = "CloudFront distribution ID"
}

variable "iam_user_name" {
  description = "Name of iam user"
  type        = string
}

variable "iam_user_arn" {
  description = "Name of iam user"
  type        = string
  default = "null"
}

variable "policy_type" {
  description = "access type wheather its a cloudfront or iam user"
  type        = string
  default = "public_iam"
}