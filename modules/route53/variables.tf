variable "zone_name" {
  description = "The name of the hosted zone"
  type        = string
}

variable "record_name" {
  description = "The name of the DNS record"
  type        = string
}

variable "record_type" {
  description = "The type of DNS record (e.g., A, CNAME)"
  type        = string
}

variable "ttl" {
  description = "The TTL of the DNS record"
  type        = number
  default     = 300
}

variable "records" {
  description = "The list of record values"
  type        = list(string)
}
