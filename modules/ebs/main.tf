resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.ebs_size

  tags = {
    Name = "jenkins-ebs"
  }
}
