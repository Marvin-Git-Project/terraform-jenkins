output "sg_id" {
  description = "ID du security group a attacher a lEIP et lEC2"
  value       = aws_security_group.this.id
}
