variable "secret_name" {
  description = "Name of the secret"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
}

variable "secret_values" {
  description = "Key-value pairs to store in the secret"
  type        = map(string)
}