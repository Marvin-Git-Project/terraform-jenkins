output "public_ip" {
  description = "Adresse IP publique fixe de lEC2"
  value       = aws_eip.this.public_ip
}

output "public_dns" {
  description = "Nom de domaine public de lEC2"
  value       = aws_eip.this.public_dns
}
