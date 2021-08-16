#!/bin/bash
sudo apt update
sudo apt-get install tinyproxy -y
sudo echo "Allow ${ec2_public_ip}" >> /etc/tinyproxy/tinyproxy.conf
sudo systemctl restart tinyproxy