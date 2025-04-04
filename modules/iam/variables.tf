variable "iam_user_name" {
  description = "The name of the IAM user"
  type        = string
}

variable "iam_policies" {
  description = "Map of policy names to policy file paths"
  type        = map(string)
}

variable "resource_arn_mapping" {
  description = "Mapping of policy names to the corresponding resource ARNs"
  type        = map(string)
}

variable "user_policy_mapping" {
  description = "Mapping of policies to attach to the IAM user"
  type        = map(string)
}

variable "iam_role_name" {
  description = "Optional IAM role name. Leave empty to skip role creation."
  type        = string
  default     = ""
}

variable "trusted_services" {
  description = "Optional list of trusted services for role assumption."
  type        = list(string)
  default     = []
}

variable "role_policy_mapping" {
  description = "Mapping of policies to attach to a role. Only used when role is defined."
  type        = map(string)
  default     = {}
}
