#!/bin/bash
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker $USER
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
mkdir app && cd app
cat > docker-compose.yml << EOF
version: "3"
services:
  default-lb:
    restart: "always"
    image: bashox/onedot:v1
    depends_on:
      - app1
      - app2
    ports:
      - 8888:80

  app1:
    restart: "always"
    image: bashox/onedotapp:v5bullseye
    user: 0:0
    environment:
      - PORT=1111
    
  app2:
    restart: "always"
    image: bashox/onedotapp:v5bullseye
    user: 0:0
    environment:
      - PORT=2222

EOF
sudo docker-compose up