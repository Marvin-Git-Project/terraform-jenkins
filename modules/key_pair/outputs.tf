output "key_name" {
  description = "Nom de la cle a passer a linstance EC2"
  value       = aws_key_pair.this.key_name
}

output "private_key" {
  description = "Contenu de la cle privee SSH"
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
}
