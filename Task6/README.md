# Task 6: Jenkins. Automate, Manage and Control

============================================================
 
## Important points:
============================================================
Read about Jenkins. What is Jenkins and what is it used for? Ways of using. What is a declarative and imperative approach? 

**This part of the assignment is accomplished by the free [Jenkins from zero to Hero](https://www.youtube.com/playlist?list=PLUsYKMNDC3Xt83is7QVoZeTKx6fhcA5by) course**
 
Tasks:
1. Install Jenkins. It must be installed in a docker container.
**This part of the assignment is accomplished by installing Jenkins as Docker Container on AWS EC2 Ubuntu Server by using Terraform(see main.tf and jenkins-docker-install-aws.sh file)**

> For Jenkins to be fully functional we need to open access to port **8080**. 
> After installing we need to enter password which can find by the location:
```
/var/jenkins_home/secrets/initialAdminPassword 
```

2. Install necessary plugins (if you need).
**This part of the assignment is accomplished by installing necessary plugins**
> Jenkins operates at http://18.170.226.13:8080/

3. Configure several (2-3) build agents. Agents must be run in docker.

**This part of the assignment is accomplished according to the [documentation](https://www.jenkins.io/doc/book/using/using-agents/):** 

>I encountered a problem while performing the task according to document:
```
[SSH] Opening SSH connection to localhost:22.
```
>The problem was solved by replacing the image **alpine** with **latest**

4. Create a Freestyle project. Which will show the current date as a result of execution.
**This part of the assignment is accomplished by creating Freestyle project named "jenkins-job"**

5. Create Pipeline which will execute docker ps -a in docker agent, running on Jenkins master’s Host.

**To do this part of the assignment, we need to make the necessary configurations in docker:**

1.  Mount docker data to new container
```
docker run -d --rm --name=agent1 -p 22:22 \
-e "JENKINS_AGENT_SSH_PUBKEY=my_pub_key" \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/usr/bin/docker jenkins/ssh-agent:latest
```
2. Give permissions to the user inside the container:
  Login to container as a root user:
```
docker exec -u 0 -it 63883290ee69 bash
```
  Change the permission:
```
chmod 666 /var/run/docker.sock 
```

3. Create and run the job
**Output should be as follow**:
```
Started by user Emil 
Running as SYSTEM
Building remotely on agent1 in workspace /home/jenkins/workspace/docker-ps-command
[docker-ps-command] $ /bin/sh -xe /tmp/jenkins3704305653727473485.sh
+ docker ps -a
CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS                     PORTS                                                                                      NAMES
f48abd33fad6   jenkins/ssh-agent:latest   "setup-sshd"             19 minutes ago   Up 19 minutes              0.0.0.0:22->22/tcp, :::22->22/tcp                                                          agent1
0ddce3ccf4a0   jenkins/ssh-agent:latest   "setup-sshd find -na���"   2 hours ago      Exited (0) 2 hours ago                                                                                                adoring_sammet
0210f640d9a6   jenkins/ssh-agent:latest   "setup-sshd ls -la /���"   2 hours ago      Exited (0) 2 hours ago                                                                                                awesome_shirley
c53cec4c6cc4   jenkins/ssh-agent:latest   "setup-sshd ls -la /���"   2 hours ago      Exited (0) 2 hours ago                                                                                                frosty_haslett
7292b143afaf   appcontainers/jenkins      "/bin/sh -c /bin/bash"   7 hours ago      Exited (137) 6 hours ago                                                                                              jenkins-keys
c5067c3149e7   jenkins/jenkins:lts        "/sbin/tini -- /usr/���"   25 hours ago     Up 25 hours                0.0.0.0:8080->8080/tcp, :::8080->8080/tcp, 0.0.0.0:50000->50000/tcp, :::50000->50000/tcp   pensive_gould
Finished: SUCCESS
```

6. Create Pipeline, which will build artefact using Dockerfile directly from your github repo (use Dockerfile from previous task).
**To do this part of the assignment, we need to make the necessary steps in Jenkins:**
1. Connect to github repository with necessary credentials
2. Build a Jenkinsfile and push it to repository
> Jenkinsfile have a folloving content

```
pipeline {
    agent { label "agent1" }
    stages {
        stage("build") {
            steps {
                sh "docker build -t jenkins_image -f Task4/Dockerfile ."         
            }
        }
        stage("run") {
            steps {
                sh "docker run -rm jenkins_image"                
            }
        }
    }
}
```
3. Create a pipline and run a job
> Pinpline named by docker-build

4. After running job:
**Output should be as follow**:
```
Started by user Emil 
Obtained Jenkinsfile from git https://github.com/gissarsky/exadel_devops.git
Running in Durability level: MAX_SURVIVABILITY
[Pipeline] Start of Pipeline
[Pipeline] node
Running on agent1 in /home/jenkins/workspace/docker-build
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
Selected Git installation does not exist. Using Default
The recommended git tool is: NONE
using credential github-credentials
Fetching changes from the remote Git repository
 > git rev-parse --resolve-git-dir /home/jenkins/workspace/docker-build/.git # timeout=10
 > git config remote.origin.url https://github.com/gissarsky/exadel_devops.git # timeout=10
Fetching upstream changes from https://github.com/gissarsky/exadel_devops.git
 > git --version # timeout=10
 > git --version # 'git version 2.20.1'
using GIT_ASKPASS to set credentials 
 > git fetch --tags --force --progress -- https://github.com/gissarsky/exadel_devops.git +refs/heads/*:refs/remotes/origin/* # timeout=10
Checking out Revision 6249e7de5541f8e25c67ba4d141bd8ddce1fd3d9 (refs/remotes/origin/master)
Commit message: "Task6 modified added path to file"
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 6249e7de5541f8e25c67ba4d141bd8ddce1fd3d9 # timeout=10
 > git rev-list --no-walk 0d4c96321145b8899f3995f945f1a50757a9d8fb # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (build)
[Pipeline] sh
+ docker build -t jenkins_image -f Task4/Dockerfile .
Sending build context to Docker daemon  167.4kB

Step 1/4 : FROM nginx:alpine
alpine: Pulling from library/nginx
29291e31a76a: Pulling fs layer
e82f830de071: Pulling fs layer
d7c9fa7589ae: Pulling fs layer
3c1eaf69ff49: Pulling fs layer
bf2b3ee132db: Pulling fs layer
9a6ac07b84eb: Pulling fs layer
3c1eaf69ff49: Waiting
bf2b3ee132db: Waiting
9a6ac07b84eb: Waiting
d7c9fa7589ae: Verifying Checksum
d7c9fa7589ae: Download complete
29291e31a76a: Verifying Checksum
29291e31a76a: Download complete
e82f830de071: Verifying Checksum
e82f830de071: Download complete
3c1eaf69ff49: Verifying Checksum
3c1eaf69ff49: Download complete
bf2b3ee132db: Verifying Checksum
bf2b3ee132db: Download complete
9a6ac07b84eb: Verifying Checksum
9a6ac07b84eb: Download complete
29291e31a76a: Pull complete
e82f830de071: Pull complete
d7c9fa7589ae: Pull complete
3c1eaf69ff49: Pull complete
bf2b3ee132db: Pull complete
9a6ac07b84eb: Pull complete
Digest: sha256:f01a7a92c6b7ab134b3a924a0c9b0b487bfb890d1563773fefc2229ce55e4ca3
Status: Downloaded newer image for nginx:alpine
 ---> 7ce0143dee37
Step 2/4 : LABEL maintainer="gemil@mail.ru"
 ---> Running in be2f51e0305e
Removing intermediate container be2f51e0305e
 ---> 6793976e69d0
Step 3/4 : COPY . /usr/share/nginx/html
 ---> 4fe6dd401eb8
Step 4/4 : EXPOSE 8080
 ---> Running in db7b243e9249
Removing intermediate container db7b243e9249
 ---> 66de0aabdfa1
Successfully built 66de0aabdfa1
Successfully tagged jenkins_image:latest
```
7. Pass  variable PASSWORD=QWERTY! To the docker container. Variable must be encrypted!!!
**This part of the assignment is accomplished according to this [documentation](https://emilwypych.com/2019/06/15/how-to-pass-credentials-to-jenkins-pipeline/) course**

>The following file need to be copied to the pipline job
```
withCredentials([usernameColonPassword(credentialsId: 'querty', variable: 'PASSWORD')]) {
    sh 'docker container run -d -e PASSWORD='${PASSWORD}' --name jenkis_container jenkins_image'
}
```
 
EXTRA:
1. Create a pipeline, which will run a docker container from Dockerfile at the additional VM.
2. Create an ansible playbook, which will deploy Jenkins.
3. Deploy a local docker registry, upload a docker image there, download img from your local docker registry and run the container.
4. Configure integration between Jenkins and your Git repo. Jenkins project must be started automatically if you push or merge to master, you also must see Jenkins last build status(success/unsuccess)   in your Git repo.