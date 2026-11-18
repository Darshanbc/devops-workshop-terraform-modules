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

variable "ingress_rules" {
  description = "Inbound security group rules for the workshop Jenkins host."
  type = list(object({
    description      = optional(string)
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), [])
    ipv6_cidr_blocks = optional(list(string), [])
    prefix_list_ids  = optional(list(string), [])
    security_groups  = optional(list(string), [])
    self             = optional(bool, false)
  }))
  nullable = false
}
