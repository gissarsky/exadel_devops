# Task 4: Docker
=====================================================
Docs:
[Read documentation about docker](https://docs.docker.com/)
 
## Tasks:
======================================================
1. Install docker. (Hint: please use VMs or Clouds  for this.)
   1.1. **EXTRA** Write bash script for installing Docker. 
  
**This part of the assignment is accomplished by the following script:** 
```
#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo usermod -aG docker ubuntu
```
 
2. Find, download and run any docker container "hello world". (Learn commands and   parameters to create/run docker containers.

**This part of the assignment is accomplished by the following script:** 
```
sudo docker run hello-world
```

2.1. **EXTRA** Use image with html page, edit html page and paste text: <Username> **_Sandbox 2021_**

```

```

3. Task

3.1. Create your Dockerfile for building a docker image. Your docker image should run any web application (nginx, apache, httpd). Web application should be located inside the docker image. 
**This part of the assignment is accomplished by the following command:** 
```
sudo docker container run --rm -d --name web -p 8080:80 nginx
```
3.1.1. **EXTRA** For creating docker image use clear basic images (ubuntu, centos, alpine, etc.)
**This part of the assignment is accomplished by the following command line in Dockerfile:** 

```
FROM nginx:alpine
LABEL maintainer="gemil@mail.ru"
COPY ./index.html /usr/share/nginx/html/index.html
```

**Build an image with name exadel-devops**:

```
docker image build  -t exadel-devops .
```

**Output should be as follow**:
```
Successfully built b103c9f07fc2
Successfully tagged exadel-devops:latest
```

**Check an image**:

```
docker image ls
```

**Output should be as follow**:

```
ubuntu@ip-10-0-10-139:~/docker/public_html$ docker image ls
REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
exadel-devops   latest    b103c9f07fc2   3 minutes ago   22.8MB
nginx           alpine    7ce0143dee37   6 days ago      22.8MB
nginx           latest    08b152afcfae   3 weeks ago     133MB
```

**Run a container named ngnix from exadel-devops image on port 8080**:
```
docker container run -d --name ngnix -p 8080:8080 exadel-devops
```

**Check a running container**:

```
docker container ls
```

**Check a running web page**:

```
ubuntu@ip-10-0-10-139:~$ curl localhost:8080
<html>
<body bgcolor=blue>
<center><h2><p><font color=red>Hello Exadel DevOps World! OS version - Ubuntu Linux</h2></center>
</body>
</html>
```

3.2. Add an environment variable "DEVOPS=<username> to your docker image

**This part of the assignment is accomplished by define the variable and its value when running the container:** 

```
docker container run -d --name ngnix --env DEVOPS=emilgaripov -p 8080:8080 exadel-devops
```
**Cheking output docker exec command. The output should be as follow**:

```
ubuntu@ip-10-0-10-139:~$ docker exec ngnix env | grep DEVOPS | cut -d'=' -f2
emilgaripov
```

3.2.1. **EXTRA** Print environment variable with the value on a web page (if environment variable changed after container restart - the web page must be updated with a new value)

```

```
 
4. Push your docker image to [docker hub](https://hub.docker.com/). Create any description for your Docker image. 

**This part of the assignment is accomplished by following lines of command** 
1. **Give a tag to the image**
```
docker image tag exadeldevops/docker exadeldevops/docker:testing
```
2. **Push the image to the repository**

```
docker image push exadeldevops/docker:testing 
```
[The link to the image](https://hub.docker.com/layers/162803469/exadeldevops/docker/testing/images/sha256-644542e7286fe608ef991abb74f57320b9595d7c1dd6572d198b0187213bd61e?context=repo) 

4.1. **EXTRA** Integrate your docker image and your github repository. Create an automatic deployment for each push. (The Deployment can be in the “Pending” status for 10-20 minutes. This is normal).

**This part of the assignment is accomplished by Github Actions from the [main.yml file](https://github.com/gissarsky/exadel_devops/tree/master/.github/workflows)** 

 
5.  Create docker-compose file. Deploy a few docker containers via one docker-compose file. 
  - first image - your docker image from the previous step. 5 nodes of the first image should be run;
  - second image - any java application;
  - last image - any database image (mysql, postgresql, mongo or etc.).
    Second container should be run right after a successful run of a database container.

**This part of the assignment is accomplished by the docker-compose1.yml**

```
version: "3.4"
services:
	exadeldevops: # My image
        image: exadeldevops/docker
        ports:
            - "8080:8080"
        volumes: 
    java: # Java image
        container_name: exadeljava
        image: openjdk:8
        volumes:
        - ./:/app
        working_dir: /app
        ports:
            - 8080:8080
        depends_on: # Starts after starting mysql database
            - mysql_db
            links:
            - mysql_db:app_db
        mysql_db:
            image: "mysql:8.0"
            restart: always
            ports:
                - 3306:3306
            environment:
                MYSQL_DATABASE: java_to_dev_app_db
                MYSQL_USER: java_to_dev
                MYSQL_PASSWORD: mysqlpasswd
                MYSQL_ROOT_PASSWORD: mysqlrootpasswd 
```

5.1. **EXTRA** Use env files to configure each service.

**This part of the assignment is accomplished by the docker-compose2.yml, exadeldevops.env  and mysql.env files in the Docker Folder**
 
**The task results is the docker/docker-compose files in your GitHub repository**
