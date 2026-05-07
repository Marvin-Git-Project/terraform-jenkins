#!/bin/bash
apt-get update -y
apt-get upgrade -y
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