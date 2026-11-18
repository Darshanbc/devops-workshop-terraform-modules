terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_sensitive_file" "this" {
  filename        = var.fileName
  content         = var.content
  file_permission = var.filePermission
}
