#!/bin/bash
sudo echo "<html><body bgcolor=blue><center><h2><p><font color=red>Hello Exadel DevOps World! OS version - Ubuntu Linux</h2></center></body></html>" > /home/ubuntu/index.html
sudo wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo chown -R ubuntu:ubuntu /etc/apt
sudo echo "deb http://nginx.org/packages/ubuntu xenial nginx" >> /etc/apt/sources.list
sudo echo "deb-src http://nginx.org/packages/ubuntu xenial nginx" >> /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu bionic-security main" | sudo tee -a /etc/apt/sources.list.d/bionic.list
sudo apt -y update
apt-cache policy libssl1.0-dev
sudo apt-get -y install libssl1.0-dev
sudo apt-get -y install nginx
sudo service nginx start
sudo chown -R ubuntu:ubuntu /etc/nginx/conf.d
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak
sudo echo "server {root /home/ubuntu;}" > /etc/nginx/conf.d/server1.conf
sudo nginx -s reload
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo usermod -aG docker ubuntu
