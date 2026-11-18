variable "repository_name" {
  description = "Name of the private ECR repository, optionally including a namespace."
  type        = string
  nullable    = false
}

variable "image_tag_mutability" {
  description = "Whether image tags can be overwritten. Exclusion modes require wildcard filters."
  type        = string
  default     = "IMMUTABLE"
  nullable    = false

  validation {
    condition     = contains(["IMMUTABLE", "MUTABLE", "IMMUTABLE_WITH_EXCLUSION", "MUTABLE_WITH_EXCLUSION"], var.image_tag_mutability)
    error_message = "Use IMMUTABLE, MUTABLE, IMMUTABLE_WITH_EXCLUSION, or MUTABLE_WITH_EXCLUSION."
  }
}

variable "image_tag_mutability_exclusion_filters" {
  description = "Wildcard tag patterns whose mutability is reversed in an exclusion mode."
  type        = set(string)
  default     = []
  nullable    = false

  validation {
    condition = (
      endswith(var.image_tag_mutability, "_WITH_EXCLUSION")
      ? length(var.image_tag_mutability_exclusion_filters) >= 1 && length(var.image_tag_mutability_exclusion_filters) <= 5
      : length(var.image_tag_mutability_exclusion_filters) == 0
    )
    error_message = "Provide one to five filters for an exclusion mode and leave filters empty for IMMUTABLE or MUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable repository-level basic scanning on push. Set to null to omit the repository scanning block and use registry settings."
  type        = bool
  default     = true
}

variable "encryption" {
  description = "Repository encryption at rest. Set kms_key to a customer-managed key ARN for KMS or KMS_DSSE, or omit it to use the AWS-managed ECR key."
  type = object({
    encryption_type = optional(string, "AES256")
    kms_key         = optional(string)
  })
  default  = {}
  nullable = false

  validation {
    condition = (
      contains(["AES256", "KMS", "KMS_DSSE"], var.encryption.encryption_type)
      && (var.encryption.encryption_type != "AES256" || var.encryption.kms_key == null)
    )
    error_message = "Use AES256, KMS, or KMS_DSSE for encryption_type. Set kms_key only with KMS or KMS_DSSE."
  }
}

variable "force_delete" {
  description = "Allow Terraform to delete the repository while it still contains images."
  type        = bool
  default     = false
  nullable    = false
}

variable "lifecycle_policy" {
  description = "Optional ECR image lifecycle policy as a JSON string."
  type        = string
  default     = null

  validation {
    condition     = var.lifecycle_policy == null || can(keys(jsondecode(var.lifecycle_policy)))
    error_message = "The lifecycle policy must be a JSON object."
  }
}

variable "repository_policy" {
  description = "Optional ECR repository access policy as a JSON string."
  type        = string
  default     = null

  validation {
    condition     = var.repository_policy == null || can(keys(jsondecode(var.repository_policy)))
    error_message = "The repository policy must be a JSON object."
  }
}

variable "tags" {
  description = "AWS tags to assign to the repository."
  type        = map(string)
  default     = {}
  nullable    = false
}
