# Task 5: Ansible for beginners
 
## Important points:
====================================================================================== 
1. Read documentation about System configuration management.
2. Learn about the advantages and disadvantages of Ansible over other tools.
3. Become familiar with ansible basics and YAML syntax.
4. Basics of working with Ansible from the official documentation
EXTRA Read the Jinja2 templating documentation

**This part of the assignment is accomplished by the free [JSON PATH Quiz" ](https://kodekloud.com/courses/json-path-quiz/)**


### Tasks:
Deploy three virtual machines in the Cloud. Install Ansible on one of them (control_plane)

**This part of the assignment is accomplished by the terraform main.tf and ansible-install-ubuntu.sh files**

> After running the **"terraform apply"** command, 3 AWS EC2 instances servers will be deployed. Two servers named "aws-amazoneserver-1" and "aws-amazoneserver-2" based on AWS Linux image and 1 server named "aws-ubuntuserver" based on Ubuntu image. Ansilbe will be installed on the Ubuntu server (see the file ansible-install-ubuntu.sh) as control plane

Ping pong - execute the built-in ansible ping command. Ping the other two machines.

**This part of the assignment is accomplished by next steps**
1. By creating a **host** file on the Ubuntu server with the ip addresses of the servers. Connection via ssh is only allowed via a private ip-address range - 10.0.10.0/24:

```
[ec2]
10.0.10.202
10.0.10.187

[ec2:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_user=ec2-user
```
2. By sending a **ping** command to the servers using the ping module:
```
ansible ec2 -i hosts -m ping
```

**Output should be as follow**:

```
ubuntu@ip-10-0-10-51:~/ansible$ ansible ec2 -i hosts -m ping
[WARNING]: Platform linux on host 10.0.10.202 is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
10.0.10.202 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
[WARNING]: Platform linux on host 10.0.10.187 is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
10.0.10.187 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
ubuntu@ip-10-0-10-51:~/ansible$
```
My First Playbook: write a playbook for installing Docker on two machines and run it.

**This part of the assignment is accomplished by next steps**

> There will be 3 AWS EC2 instances servers deployed using Terraform. Two servers named "aws-amazoneserver-1" and "aws-amazoneserver-2" based on the AWS Linux image and 1 server named "aws-ubuntuserver" based on the Ubuntu image. Ansilbe will be installed on the Ubuntu server (see the file ansible-install-ubuntu.sh) as the control plane. 
Access via ssh to the "aws-amazoneserver-1" and "aws-amazoneserver-2" servers is only available via subnet 10.0.10.0.24, where all 3 installed servers are located. 
External ssh access is only available to the server "aws-ubuntuserver" on which Ansible will be installed.


>Therefore it was decided to send the hosts, ansible.cfg and playbook "deploy-docker.yaml" to deploy docker to the server "aws-ubuntuserver" using the terraform provisioner "file"(see the file main.tf) 


1. After all the necessary files have been transferred to "aws-ubuntuserver", you have to connect via ssh to the server and run the command:

```
ansible-playbook deploy-docker.yaml
```

**Output should be as follow**:

```
ubuntu@ip-10-0-10-125:~/docker$ ansible-playbook deploy-docker.yaml

PLAY [Install Docker] **************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************
Enter passphrase for key '/home/ubuntu/.ssh/id_rsa':
[WARNING]: Platform linux on host 10.0.10.227 is using the discovered Python interpreter at /usr/bin/python, but future
installation of another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.11/reference_appendices/interpreter_discovery.html for more information.
ok: [10.0.10.227]
ok: [10.0.10.160]

TASK [Install Docker] **************************************************************************************************

changed: [10.0.10.227]
changed: [10.0.10.160]

PLAY RECAP *************************************************************************************************************
10.0.10.160                : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
10.0.10.227                : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
       
EXTRA 1. Write a playbook for installing Docker and one of the (LAMP/LEMP stack, Wordpress, ELK, MEAN - GALAXY do not use) in Docker.
EXTRA 2. Playbooks should not have default creds to databases and/or admin panel.
EXTRA 3. For the execution of playbooks, dynamic inventory must be used (GALAXY can be used).
 
The result of this task will be ansible files in your GitHub.