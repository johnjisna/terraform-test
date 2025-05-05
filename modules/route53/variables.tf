variable "zone_name" {
  description = "The domain name of the existing Route53 hosted zone"
  type        = string
}

variable "record_name" {
  description = "Name of the DNS record (e.g., www.example.com)"
  type        = string
}

variable "record_type" {
  description = "Type of DNS record"
  type        = string
}

variable "ttl" {
  description = "Time to Live for DNS record"
  type        = number
  default     = 300
}

variable "records" {
  description = "List of DNS record values"
  type        = list(string)
}
