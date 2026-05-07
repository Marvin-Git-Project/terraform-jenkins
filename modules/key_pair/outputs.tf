output "key_name" {
  description = "Nom de la cle a passer a linstance EC2"
  value       = aws_key_pair.this.key_name
}
