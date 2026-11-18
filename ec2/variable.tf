variable "ami_id" {
  description = "Linux AMI ID in the selected AWS region, compatible with the instance type."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the workshop Jenkins host."
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "Existing public subnet ID with an internet gateway route."
  type        = string
}

variable "ssh_cidr" {
  description = "Allowed SSH source as a single public IPv4 address in /32 CIDR notation."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_cidr)) && endswith(var.ssh_cidr, "/32")
    error_message = "Use a single IPv4 address in /32 CIDR notation."
  }
}
