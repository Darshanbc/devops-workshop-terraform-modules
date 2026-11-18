variable "fileName" {
  type = string
}

variable "content" {
  type      = string
  sensitive = true
}

variable "filePermission" {
  type = string
}
