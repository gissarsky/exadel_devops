# Task 8: K8s, Clouds, CI/CD. Just do it!
=======================================

## Important points:
=======================================

After the completion of development you will show a presentation of the project (Share screen + documentation).
=======================================

### Tasks:

### 1. Select an application from the list  (pay attention to the date of the last change in the project ): https://github.com/unicodeveloper/awesome-opensource-apps

>This task is accomplished by the following steps:

1. Deployed 2 Ubuntu servers() on AWS EC2 using terraform (see main.tf)
  2. At the same time, with the deployment of Ubuntu servers, installed Docker, Docker Compose by using terraform  (see main.tf, docker-install.sh files).

  3. From the list of submitted applications, [Shuup - an Open Source E-Commerce Platform](https://github.com/shuup/shuup) was chosen.


### 2. Select an CI/CD. You can choose any option, but we recommend looking here: 
https://pages.awscloud.com/awsmp-wsm-dev-workshop-series-module3-evolving-to-continuous-deployment-ty.html
Select Cloud Service provider for your infrastructure.

  1. This part of the job is done by installing Jenkins and Jenkins Agent on the AWS EC2 Ubuntu Servers accordingly during Ubuntu server deployment using terraform (see files main.tf, docker-jenkins-install.sh, docker-install.sh).


> For Jenkins to be fully functional we need to open access to port **8080**. 

Jenkins operates at **http://35.178.176.245:8080**

> After installing we need to enter password which can find by the location:
```
/var/jenkins_home/secrets/initialAdminPassword 
```

  2. Install necessary plugins (if you need).
**This part of the assignment is accomplished by installing necessary plugins**


  3. We also need to install Jenkins Agent to the Ubuntu Server called "aws-ubuntu-jenkins-agent" 

**This part of the assignment is accomplished by running following commands:**
```
docker run -d --rm --name=jenkinsagent -p 22:22 \
-e "JENKINS_AGENT_SSH_PUBKEY=my_pub_key" \
-v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v $(which docker):/usr/bin/docker jenkins/ssh-agent:latest
```

>Since the jenkins/jenkins image does not come with docker-compose we must install docker-compose inside the jenkins agent container.

**This part of the work is done as follows**.

  4. Login to the container as a root user 

  ```
  docker exec -u 0 -it 38f18373abcc bash
  ```

  5. Installing Docker Compose

```
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

```

  6. Granting access rights to launch docker compose and docker inside container
```
chmod +x /usr/local/bin/docker-compose
chmod 666 /var/run/docker.sock
```

  7. Checking the version of Docker Compose inside container
```
docker-compose --version
```

  8. The output should be as follows

```
docker-compose version 1.29.2, build 5becea4c
```

  9. Testing Docker Compose by running the Jenkins file(see file Jenkinsfile-1) in Jenkins Pipeline from the repository - https://github.com/gissarsky/shuup.git

![Jenkins-Compose-Test](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/jenkins_compose_sucsess.png?raw=true)
![Jenkins-Stage-View](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/jenkins_stage_view.png?raw=true)


>When deploying an application via Jenkins, the following error occured 

```
can't find Rust compiler
```

**The problem was solved through the following changes in the Dockerfile(see Dockerfile):**

  10. Added line after "ARG editable=0": 
```
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
```

  11. Added additional apt-get install modules:
```
build-essential \
libssl-dev \
libffi-dev \
```

  12. After solving the problem described in step 9, the application was deployed using Jenkins on the server.

![Jenkins-Compose-Test](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/shuup-deploy-success-pipeline.png?raw=true)

![Jenkins-Compose-Test](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/welcome-shuup.png?raw=true)

**You can see the working application by [link](http://18.170.77.58:8000/):**



### 3. Use Kubernetes as an orchestration (cloud provider is recommended);

  1. This part of the job is done by deploying the Kubernetes Cluster on the AWS EKS by using terraform (see files eks-cluster.tf, vpc.tf).**

  The result of deploying EKS by terraform:

  ![Jenkins-Compose-Test](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/EKS-Cluster_result.png?raw=true)
  

### 4. Complete CI/CD Pipeline with EKS and DockerHub

  **Used Jenkins pipeline to deploy to Kubernetes Cluster**

  **Prerequisites:**

  1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) command line tool inside Jenkins agent container.

  The result of installing **kubectl** inside the container:

  ![Kubectl](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/kubectl_result.png?raw=true)

  2. Install [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) tool inside Jenkins agent container

  The result of installing **aws-iam-authenticator** inside the container:

  ![AWS IAM Authenticator](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/aws-iam_result.png?raw=true)

  3. Install [git](https://phoenixnap.com/kb/how-to-install-git-on-ubuntu) inside Jenkins agent container

  The result of installing **git** inside the container:

  ![Git](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/git_result.png?raw=true)

  4. Install [envsubst](https://manpages.ubuntu.com/manpages/focal/man1/envsubst.1.html) inside Jenkins agent container

```
 apt install gettext-base
```

  >**envsubst** is needed to handle environment variables that are configured in Jenkinsfile and will be passed as arguments. 


  5. Create [kubeconfig](https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html) file to connect to EKS cluster.

  6. We need to create a **kube config** file and make it accessible from the container:

```
apiVersion: v1
clusters:
- cluster:
    server: <endpoint-url>
    certificate-authority-data: <base64-encoded-ca-cert>
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "<cluster-name>"
        # - "-r"
        # - "<role-arn>"
      # env:
        # - name: AWS_PROFILE
        #   value: "<aws-profile>"
```
  >In the server: <endpoint-url> field you must specify the Endpoint data from the cluster settings

  ![Endpoint](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/eks_endpoint.png?raw=true)

  >In the certificate-authority-data: <base64-encoded-ca-cert> field you must specify the **certificate authority** data from the cluster settings

  ![Certificate Authority](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/eks_cert_author.png?raw=true)

  >In the - "<cluster-name>" field you must specify the **cluster name**. In my case it is **exadel-devops-cluster** 

   7. Create **.kube directory** inside container inside the **/home/jenkins** directory

```
mkdir .kube
```

  8. Copy kube config file inside container to the .kube directory:

```
docker cp config ea37741d3252:/home/jenkins/.kube
```

The result of the creating the **config file** inside the container:

![Kube Config](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/kube_config_indide_containers.png?raw=true)

  9. Add AWS credentials on Jenkins for AWS account authentication

  10. Create credentials for AWS User inside Jenkins:

    - Use the **Secret text** Kind 
    - Use the **jenkins_aws_access_key_id**
    - Use the **jenkins_aws_secret_access_key**

    The result of adding credentialt to the Jenkins:

  ![AWS Jenkins Credentials](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/aws_jenkins_creds.png?raw=true)

  11. Adjust Jenkinsfile to configure EKS cluster deployment

  12. Create a Kuberntes folder with **deplyoment.yaml** and **service.yaml** files(see deplyoment.yaml and service.yaml) inside the kubernetes directory od the application repository - https://github.com/gissarsky/shuup.git

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $APP_NAME
  labels:
    app: $APP_NAME
spec:
  replicas: 3
  selector:
    matchLabels:
      app: $APP_NAME
  template: 
    metadata:
      labels:
        app: $APP_NAME
    spec:
      imagePullSecrets:
        - name: exadel-registry-key
      containers:
        - name: $APP_NAME
          image: exadeldevops/shuup:1.0
          imagePullPolicy: Always
          ports:
            - containerPort: 8000
```
  **deployment.yaml** file


```
apiVersion: v1
kind: Service
metadata:
  name: $APP_NAME
spec:
  selector:
    app: $APP_NAME
  ports:
    - protocol: TCP
      port: 8000
      targetPort: 8000
```
  **service.yaml** file


  #### Create a secret in kubernetes cluster to connect to Docker Hub.

  >The Docker Registry will be configured using the kubectl tool from the local machine. To do this, we need to do the following preparatory steps:

  **Prerequisites:**

  15. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) command line tool on local machine for further configuration of the EKS cluster

  The result of installing **kubectl**:

  ![Kubectl](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/kubectl_on_local_machines.png?raw=true)

  16. Install [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) tool.

  The result of installing **aws-iam-authenticator**:

  ![AWS IAM Authenticator](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/aws-iam-auth_on_local_machines.png?raw=true)

  17. Create secret docker-registry by the next command:

```
kubectl create secret docker-registry exadel-registry-key \
> --docker-server=docker.io \
> --docker-username=exadeldevops \
> --docker-password=mydocerhubpsw
```
    Check the output

  **The output should be as follows:**

```
gissarsky@NetDevOps:~/.kube$ kubectl get secret
NAME                  TYPE                                  DATA   AGE
default-token-x5zq9   kubernetes.io/service-account-token   3      28h
exadel-registry-key   kubernetes.io/dockerconfigjson        1      15s
gissarsky@NetDevOps:~/.kube$
```

  
18. We need to configure Jenkinsfile to build an image from source files when you start the pipeline (see Jenkinsfile in repository - https://github.com/gissarsky/shuup.git
) and push it to Docker Hub. 

**This part is implemented by the "build image" stage of the Jenkins file code**

```
        stage("build image") {
            steps {
                script {
                    echo "building the shuup docker image.."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PSW', usernameVariable: 'USER')]) {
                        sh 'docker build -t exadeldevops/shuup:1.0 .'
                        sh "docker login -u $USER -p $PSW"
                        sh 'docker push exadeldevops/shuup:1.0'
                    }    
                }
            }
        }
```
  **Jenkinsfile's** Docker hub image creation stage.

  19. Check the [Docker Hub Repository](https://hub.docker.com/repository/docker/exadeldevops/shuup). :

  ![AWS IAM Authenticator](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/docker-hub_image.png?raw=true)

  20. Last we must configure the deployment of the application to the EKS cluster, using the created image of the application from the Docker Hub 

  **This part is implemented by the "deployment" stage of the Jenkins file code**

```
        stage("deployment") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
                APP_NAME = 'shuup-app'
            }
            steps {
                sh 'envsubst < kubernetes/deployment.yaml | kubectl apply -f -'
                sh 'envsubst < kubernetes/service.yaml | kubectl apply -f -'                 
            }
        }
    }
}
```
  **Jenkinsfile's** Docker hub image creation stage.


  21. Run the pipeline:

  **The output of the Docker hub image build stage:**
  ![Pods](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/docker-hub_image_builed_stage.png?raw=true)

  **The output of the deployment to the EKS cluster:**
  ![Pods](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/eks_shuup_deployment_stage.png?raw=true)
 

  22. Stage Success view:

  ![Pods](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/stage_view.png?raw=true)


  23. Check the current state of pods:

  ![Pods](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/kubectl_get_pod.png?raw=true)


  24. Check the current state of container

```
kubectl describe pod shuup-app-788fc4bc45-7zfkj
```

**The output should be as follows:**

```
gissarsky@NetDevOps:~/.kube$ kubectl describe pod shuup-app-788fc4bc45-7zfkj
Name:         shuup-app-788fc4bc45-7zfkj
Namespace:    default
Priority:     0
Node:         ip-10-0-2-143.eu-west-2.compute.internal/10.0.2.143
Start Time:   Wed, 15 Sep 2021 16:16:32 +0500
Labels:       app=shuup-app
              pod-template-hash=788fc4bc45
Annotations:  kubernetes.io/psp: eks.privileged
Status:       Running
IP:           10.0.2.185
IPs:
  IP:           10.0.2.185
Controlled By:  ReplicaSet/shuup-app-788fc4bc45
Containers:
  shuup-app:
    Container ID:   docker://e9fd75b5cbb75a66ff637d5c8c4e8c69227728aea41224c86186a165a2caf95f
    Image:          exadeldevops/shuup:1.0
    Image ID:       docker-pullable://exadeldevops/shuup@sha256:e99c6d3637428f3eeabd1f2d85c0ffa3047c5001f6f737441083fd1bf169c0d8
    Port:           8000/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 15 Sep 2021 16:19:39 +0500
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-277w2 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-277w2:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  12m   default-scheduler  Successfully assigned default/shuup-app-788fc4bc45-7zfkj to ip-10-0-2-143.eu-west-2.compute.internal
  Normal  Pulling    12m   kubelet            Pulling image "exadeldevops/shuup:1.0"
  Normal  Pulled     9m9s  kubelet            Successfully pulled image "exadeldevops/shuup:1.0" in 3m5.988816199s
  Normal  Created    9m9s  kubelet            Created container shuup-app
  Normal  Started    9m9s  kubelet            Started container shuup-app
```

  25. Check the running service:
  **The output should be as follows:**

![Pods](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/kubectl_get_service.png?raw=true)

### 5. Monitoring with ELK

**Prerequisites:**

  26. Configure [Helm](https://helm.sh/docs/intro/install/) in the local machine

  The result of installing **helm**:

  ![HELM](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/helm install.png?raw=true)

  27. Deploying an Elasticsearch Cluster with HELM.

  ```
  $ helm repo add elastic https://Helm.elastic.co
  $ curl -O https://raw.githubusercontent.com/elastic/Helm/charts/master/elasticsearch/examples/minikube/values.yaml
  $ helm install elasticsearch elastic/elasticsearch -f ./values.yaml 
  ```

  The result of deploying **Elasticsearch Cluster**:

  ![Elasticsearch Cluster](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/elastic_test.png?raw=true)

  28.  Apply port forward to connect Elasticsearch from outside by the next command:

```
kubectl port-forward svc/elasticsearch-master 9200
```
    Check the output

  **The output should be as follows:**

```
{
  "name" : "elasticsearch-master-0",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "HmNGS0gDSW6l4FW8VwT9rQ",
  "version" : {
    "number" : "7.14.0",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1",
    "build_date" : "2021-07-29T20:49:32.864135063Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

 28.  Deploying Kibana with HELM by the next command:

 ```
 helm install kibana elastic/kibana
 ```

  The result of ideploying **Deploying Kibana**:

  ![Kibna result](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/kibana_deployed.png?raw=true)

   29.  Apply port forward to connect Kibana from outside by the next command:

```
kubectl port-forward deployment/kibana-kibana 5601
```
    Check the output

  The result of port forwarding of **Kibana**:

  ![Port Forwarding Kibana](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/kibana_port_forwarding.png?raw=true)

  30. Deploying Metricbeat with HELM by the next command:

 ```
 helm install metricbeat elastic/metricbeat
 ```

The result of deploying **Metricbeat**:

  ![Metricbeat](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/metricbeat_deployed.png?raw=true)


The result of deploying **ELK Monitoring**:

  ![Elasticsearch Cluster](https://github.com/gissarsky/exadel_devops/blob/master/Task8/images/ELK_Monitoring.png?raw=true)

### The Shuup aplication
Applicat is available by [link](ac6b81d9a876043c88189904b7339d1c-328493035.eu-central-1.elb.amazonaws.com:8000)

The project must be documented, step-by-step guides to deploy from scratch; 
EXTRA: SonarQube integration.
