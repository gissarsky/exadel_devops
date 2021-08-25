#!/bin/bash
sudo apt -y update
sudo apt install -y docker.io

# Start Jenkins
sudo docker run -id --name jenkins -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts