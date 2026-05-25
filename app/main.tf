# Déclaration des providers necessaires
terraform {
  backend "s3" {
    bucket  = "terraform-jenkins-state-marvin"
    key     = "jenkins/terraform.tfstate"
    region  = "eu-west-3"
    profile = "default"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Configuration du provider AWS
provider "aws" {
  region                   = "eu-west-3"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

# Module 1 : Paire de clés SSH
module "key_pair" {
  source   = "../modules/key_pair"
  key_name = var.key_name
}

# Module 2 : Security Group
module "security_group" {
  source        = "../modules/security_group"
  sg_name       = var.sg_name
  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}

# Module 3 : Instance EC2
module "ec2" {
  source            = "../modules/ec2"
  instance_type     = var.instance_type
  instance_name     = var.instance_name
  key_name          = module.key_pair.key_name
  sg_id             = module.security_group.sg_id
  user_data         = file("${path.module}/user_data.sh")
  availability_zone = "eu-west-3b"
}

# Module 4 : Volume EBS
module "ebs" {
  source            = "../modules/ebs"
  ebs_size          = var.ebs_size
  availability_zone = "eu-west-3b"
}

# Module 5 : IP publique
module "eip" {
  source = "../modules/eip"
}

# Attachement du volume EBS a lEC2 (couplage faible)
resource "aws_volume_attachment" "jenkins_ebs" {
  device_name  = "/dev/sdf"
  volume_id    = module.ebs.ebs_id
  instance_id  = module.ec2.instance_id
  force_detach = true

  provisioner "remote-exec" {
    inline = [
      "while [ ! -e /dev/nvme1n1 ]; do sleep 1; done",
      "sudo file -s /dev/nvme1n1 | grep -q 'ext4' || sudo mkfs -t ext4 /dev/nvme1n1",
      "sudo mkdir -p /mnt/jenkins-data",
      "sudo mount /dev/nvme1n1 /mnt/jenkins-data",
      "echo '/dev/nvme1n1 /mnt/jenkins-data ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab",
      "sudo mkdir -p /mnt/jenkins-data/docker-volumes",
      "sudo mkdir -p /etc/docker",
      "echo '{\"data-root\": \"/mnt/jenkins-data/docker-volumes\"}' | sudo tee /etc/docker/daemon.json",
      "sudo systemctl restart docker",
      "cd /opt/jenkins && sudo docker-compose up -d"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = module.key_pair.private_key
      host        = module.eip.public_ip
    }
  }
}

# Association de lEIP a lEC2 (couplage faible)
resource "aws_eip_association" "jenkins_eip" {
  instance_id   = module.ec2.instance_id
  allocation_id = module.eip.allocation_id
}

# Sauvegarde lIP et le DNS dans jenkins_ec2.txt
resource "local_file" "jenkins_info" {
  content  = "IP publique : ${module.eip.public_ip}\nNom de domaine : ${module.eip.public_dns}"
  filename = "${path.module}/jenkins_ec2.txt"
}