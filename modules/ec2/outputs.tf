output "instance_id" {
  description = "ID de linstance EC2"
  value       = aws_instance.this.id
}

output "availability_zone" {
  description = "Zone de dispo de lEC2 (necessaire pour le volume EBS)"
  value       = aws_instance.this.availability_zone
}
