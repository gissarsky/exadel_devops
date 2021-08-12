# Task3
(Note. The assignment is written using AWS as an example. You can complete the assignment using any cloud services.) 

## Important moments:
==================================================

1. Read about IaC (Infrastructure as a Сode)
2. All steps are done using Terraform , if you need any other tools besides WEB GUI, you can use them. 
3. You should not use the previously created VPC/EC2, etc. We assume that the task is executed from a “clear” AWS account with only the IAM administrator role. 
4. Passwords/Keys should not be stored on GitHub.

## Tasks:
==================================================

1. Create EC2 Instance t2.micro
  - Ubuntu
  - CentOS
Both instances must have a tag with names. 
2. EC2 Ubuntu must have Internet access, there must be incoming access: ICMP, TCP/22, 80, 443, and any outgoing access. 
3. EC2 CentOS should not have access to the Internet, but must have outgoing and incoming access: ICMP, TCP/22, 80, 443 only on the local network where EC2 Ubuntu, EC2 CentOS is located. 

**This part of the assignment is accomplished by the code described in the _main.tf_ and _terraform-vpc.tfvars_ files** 

[](@note/main.tf)

> _terraform-vpc.tfvars_ is not in the repository due to containing **sensitive data** 


4. On EC2 Ubuntu, install a web server (nginx/apache);
- Create a web page with the text “Hello World” and information about the current version of the operating system. This page must be visible from the Internet. 

**This part of the assignment is accomplished by the following bash script code described in the file _entry-script.sh_**
[](@note/entry-script.sh)
```
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
```
### Result: [Link to index.html](http://3.250.226.8/) 

**The output should be as follows**
```
Hello Exadel DevOps World! OS version - Ubuntu Linux
```

5. On EC2 Ubuntu install Docker, installation should be done according to the recommendation of the official Docker manuals 

**This part of the assignment is accomplished by the following bash script code described in the file _entry-script.sh_**

[](@note/entry-script.sh)

```
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo usermod -aG docker ubuntu
```

## EXTRA:
=================================================

6. Complete  step 1, but AMI ID cannot be hardcoded. You can hardcode operation system name, version, etc. 
7. Step 3 read as: 
EC2 CentOS should not have Internet access, but must have outgoing and incoming access: ICMP, TCP/22, 80, 443, only to EC2 Ubuntu. 
8. On EC2 CentOS install nginx (note. Remember about step 7, the task can be done in any way, it is not necessary to use terraform)
- Create a web page with the text “Hello World” and information about the current version of the operating system. This page must be visible from the  EC2 Ubuntu.

The result of steps.1-7. is a terraform files in your GitHub. +file with output terraform plan BEFORE creating infrastructure.
The result of step EXTRA 8, is or scripts (if you have one), or an explanation of how this can be implemented.
