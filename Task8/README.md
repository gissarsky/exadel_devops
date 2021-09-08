# Task 8: K8s, Clouds, CI/CD. Just do it!
=======================================

## Important points:
=======================================

After the completion of development you will show a presentation of the project (Share screen + documentation).
=======================================

Tasks:
Select an application from the list  (pay attention to the date of the last change in the project ): https://github.com/unicodeveloper/awesome-opensource-apps

**This task is accomplished by the following steps:**
1. Deployed 2 Ubuntu servers() on AWS EC2 using terraform (see main.tf)

2. At the same time, with the deployment of Ubuntu servers, installed Docker, Docker Compose by using terraform  (see main.tf, docker-install.sh files).

3. From the list of submitted applications, [Shuup - an Open Source E-Commerce Platform was chosen](https://github.com/shuup/shuup).


Select an CI/CD. You can choose any option, but we recommend looking here: 
https://pages.awscloud.com/awsmp-wsm-dev-workshop-series-module3-evolving-to-continuous-deployment-ty.html
Select Cloud Service provider for your infrastructure.

**This part of the job is done by installing Jenkins and Jenkins Agent on the AWS EC2 Ubuntu Servers accordingly during Ubuntu server deployment using terraform (see files main.tf, docker-jenkins-install.sh, docker-install.sh).**


> For Jenkins to be fully functional we need to open access to port **8080**. 

Jenkins operates at **http://35.178.212.3:8080/**

> After installing we need to enter password which can find by the location:
```
/var/jenkins_home/secrets/initialAdminPassword 
```

2. Install necessary plugins (if you need).
**This part of the assignment is accomplished by installing necessary plugins**


>We also need to install Jenkins Agent to the Ubuntu Server called "aws-ubuntu-jenkins-agent" 

**This part of the assignment is accomplished by running following commands:**
```
docker run -d --rm --name=jenkinsagent -p 22:22 \
-e "JENKINS_AGENT_SSH_PUBKEY=my_pub_key" \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/usr/bin/docker jenkins/ssh-agent:latest
```

>Since the jenkins/jenkins image does not come with docker-compose we must install docker-compose inside the container.

**This part of the work is done as follows**.
1. Login to the container as a root user 
```
docker exec -u 0 -it 38f18373abcc bash
```
2. Installing Docker Compose
```
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

```
3. Granting access rights to launch docker compose and docker inside container
```
chmod +x /usr/local/bin/docker-compose
chmod 666 /var/run/docker.sock
```
4. Checking the version of Docker Compose inside container
```
docker-compose --version
```
5. The output should be as follows

```
docker-compose version 1.29.2, build 5becea4c
```
6. Testing Docker Compose by running the Jenkins file(see file Jenkinsfile-1) in Jenkins Pipeline from the repository - https://github.com/gissarsky/shuup.git

![Jenkins-Compose-Test](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/jenkins_compose_sucsess.png?raw=true)
![Jenkins-Stage-View](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/jenkins_stage_view.png?raw=true)

7. When deploying an application via Jenkins, the following error occured 
```
can't find Rust compiler
```
**The problem was solved through the following changes in the Dockerfile(see Dokcerfile):**

1. Added line after "ARG editable=0": 
```
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
```
2. Added additional apt-get install modules:
```
build-essential \
libssl-dev \
libffi-dev \
```
8. After solving the problem described in step 7, the application was deployed using Jenkins on the server.

![Jenkins-Compose-Test](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/shuup-deploy-success-pipeline.png?raw=true)

![Jenkins-Compose-Test](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/welcome-shuup.png?raw=true)

**You can see the working application by [link](http://18.170.77.58:8000/):**

What would we like to see? The created infrastructure in which it will be possible to build, deploy and test the application.  

The main things to look out for 
Git integration;
Setup/configure CI/CD;
Application/s should be containerized;
Scheduled backups for DB and all critical data;
Logging and monitoring for your services;
Security;
Use Kubernetes as an orchestration (cloud provider is recommended);
The project must be documented, step-by-step guides to deploy from scratch; 
EXTRA: SonarQube integration.
