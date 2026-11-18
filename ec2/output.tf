output "public_ip" {
  description = "Public IPv4 address for SSH."
  value       = aws_instance.this.public_ip
}

output "private_key" {
  description = "SSH private key in OpenSSH format. Keep the Terraform state and any exported key private."
  value       = tls_private_key.ssh.private_key_openssh
  sensitive   = true
}
