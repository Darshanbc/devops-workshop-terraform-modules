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

variable "ecr_repository_arn" {
  description = "ARN of the private ECR repository this host can pull from. Leave null to omit the IAM instance profile."
  type        = string
  default     = null

  validation {
    condition     = var.ecr_repository_arn == null ? true : can(regex("^arn:[^:]+:ecr:[^:]+:[0-9]{12}:repository/[^*?]+$", var.ecr_repository_arn))
    error_message = "Use the ARN of a single private ECR repository."
  }
}
