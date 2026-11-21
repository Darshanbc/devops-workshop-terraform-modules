terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "this" {
  key_name_prefix = "workshop-jenkins-"
  public_key      = tls_private_key.this.public_key_openssh
}

resource "aws_security_group" "this" {
  name_prefix = "workshop-jenkins-"
  description = "SSH access to the workshop Jenkins host"
  vpc_id      = data.aws_subnet.this.vpc_id

  ingress = var.ingress_rules

  egress {
    description = "Outbound access for software installation"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = aws_key_pair.this.key_name
  iam_instance_profile        = one(aws_iam_instance_profile.ecr_pull[*].name)

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "workshop-jenkins"
  }
}

