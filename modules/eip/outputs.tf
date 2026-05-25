output "public_ip" {
  description = "Adresse IP publique fixe"
  value       = aws_eip.this.public_ip
}

output "public_dns" {
  description = "Nom de domaine public AWS"
  value       = aws_eip.this.public_dns
}

output "allocation_id" {
  description = "ID d allocation de lEIP pour association"
  value       = aws_eip.this.id
}