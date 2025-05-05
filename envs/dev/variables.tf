variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate for the custom domain"
  type        = string
  default     = null
}

variable "custom_domain_name" {
  description = "The custom domain name for the CloudFront distribution"
  type        = string
  default     = ""
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
  default     = "null"
}

variable "policy_type" {
  description = "access type wheather its a cloudfront or iam user"
  type        = string
  default     = "null"
}

variable "bucket_name" {
  description = "bucket name"
  type        = string
  default     = "null"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "secret_description" {
  description = "Description of the secret"
  type        = string
}

variable "secret_values" {
  description = "Key-value pairs to store in the secret"
  type        = map(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "ecr_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "ecr_image_tag_mutability" {
  description = "The tag mutability setting for the repository (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
}

variable "iam_role_name" {
  description = "Name of the IAM user for S3"
  type        = string

}

variable "trusted_services" {
  description = "List of AWS services that can assume this IAM role"
  type        = list(string)
}

variable "iam_user_name_backend" {
  description = "Name of the IAM user backend"
  type        = string

}

variable "iam_user_name_frontend" {
  description = "Name of the IAM user frontend"
  type        = string

}

variable "iam_role_name_backend" {
  description = "Name of the IAM user backend"
  type        = string

}

variable "iam_role_name_frontend" {
  description = "Name of the IAM user frontend"
  type        = string

}

variable "EC2_AMI_FILTER" {
  type        = string
  default     = null
  description = "AMI name to be used to create the EC2 instance"
}

variable "ami_id" {
  description = "The default AMI ID to use if no AMI is found by the filter."
  type        = string
}


variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "sg_description" {
  description = "Description of the security group"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    port        = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "jenkins_pub_key" {
  description = "Jenkins SSH public key"
  type        = string
}

variable "EC2_USER_DATA" {
  type        = string
  default     = ""
  description = "sh file with commands that needs to be ran in the ec2 instance during start up"
}

variable "zone_name" {
  description = "Name of the hosted zone"
  type        = string
}

variable "record_name" {
  description = "DNS record name"
  type        = string
}

variable "record_type" {
  description = "Type of DNS record"
  type        = string
}

variable "ttl" {
  description = "TTL for DNS record"
  type        = number
  default     = 300
}

variable "records" {
  description = "List of values for DNS record"
  type        = list(string)
}

variable "iam_instance_profile_name" {
  description = "Explicit name for the IAM Instance Profile"
  type        = string
  default     = "" # Make it optional by providing a default value
}

