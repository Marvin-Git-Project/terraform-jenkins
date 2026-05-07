output "public_ip" {
  description = "IP publique de linstance Jenkins"
  value       = module.eip.public_ip
}

output "public_dns" {
  description = "Nom de domaine public de linstance Jenkins"
  value       = module.eip.public_dns
}
