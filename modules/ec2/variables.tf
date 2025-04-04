variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for the EC2 instance."
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance."
  type        = string
}

variable "environment" {
  description = "Environment tag for the EC2 instance."
  type        = string
}


variable "preferred_filter" {
  description = "AMI filter for the preferred Ubuntu version (e.g. Ubuntu 24)."
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-24*-amd64-server-*"
}


variable "fallback_filter" {
  description = "AMI filter for fallback Ubuntu images."
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"
}

variable "security_group_id" {
  description = "ID of the security group to associate with the EC2 instance"
  type        = string
}

variable "jenkins_pub_key" {
  description = "Jenkins SSH public key"
  type        = string
}

