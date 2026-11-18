terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.73.0"
    }
  }
}

resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete
  tags                 = var.tags

  encryption_configuration {
    encryption_type = var.encryption.encryption_type
    kms_key         = var.encryption.kms_key
  }

  dynamic "image_scanning_configuration" {
    for_each = var.scan_on_push == null ? [] : [var.scan_on_push]

    content {
      scan_on_push = image_scanning_configuration.value
    }
  }

  dynamic "image_tag_mutability_exclusion_filter" {
    for_each = var.image_tag_mutability_exclusion_filters

    content {
      filter      = image_tag_mutability_exclusion_filter.value
      filter_type = "WILDCARD"
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.lifecycle_policy == null ? 0 : 1

  repository = aws_ecr_repository.this.name
  policy     = var.lifecycle_policy
}

resource "aws_ecr_repository_policy" "this" {
  count = var.repository_policy == null ? 0 : 1

  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy
}
