output "ebs_id" {
  description = "ID du volume EBS a attacher a lEC2"
  value       = aws_ebs_volume.this.id
}
