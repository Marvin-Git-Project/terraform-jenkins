# Recupere la derniere AMI Ubuntu Jammy (22.04) disponible sur AWS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID officiel de Canonical (editeur Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Cree linstance EC2
resource "aws_instance" "this" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  availability_zone = var.availability_zone
  vpc_security_group_ids = [var.sg_id]
  user_data = var.user_data

root_block_device {
  volume_size = 50
  volume_type = "gp3"
}

  tags = {
    Name = var.instance_name
  }
}