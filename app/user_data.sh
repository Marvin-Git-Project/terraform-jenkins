#!/bin/bash
apt-get update -y
apt-get upgrade -y

# 1. Attente et configuration du volume EBS
while [ ! -e /dev/nvme1n1 ]; do sleep 1; done
sudo file -s /dev/nvme1n1 | grep -q 'ext4' || sudo mkfs -t ext4 /dev/nvme1n1
sudo mkdir -p /mnt/jenkins-data
sudo mount /dev/nvme1n1 /mnt/jenkins-data
echo '/dev/nvme1n1 /mnt/jenkins-data ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab

# 2. Pré-configuration du dossier de données Docker
sudo mkdir -p /mnt/jenkins-data/docker-volumes
sudo mkdir -p /etc/docker
echo '{"data-root": "/mnt/jenkins-data/docker-volumes"}' | sudo tee /etc/docker/daemon.json

apt-get install -y docker.io
systemctl enable docker
systemctl start docker
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir -p /opt/jenkins
cat > /opt/jenkins/docker-compose.yml << 'EOF'
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    restart: always
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_data:/var/jenkins_home
volumes:
  jenkins_data:
EOF
cd /opt/jenkins
docker-compose up -d
