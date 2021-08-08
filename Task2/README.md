##Important moments:
==================================================

1. Read about Cloud Services. Pro and Cons Cloud VS Bare Metal infrastructure?
  - Answers:  
    - Advantages of Bare Metal such as the fact that software can access the operating system and hardware directly. This is useful for situations in which you need access to specialized hardware, or for High Performance Computing (HPC) applications in which every bit of speed counts.
    - Disadvantage of Bare Metal such as every application on the machine is using the same kernel, operating system, storage, etc.
    - Clouds provide self-service access to computing resources, such as VMs, containers, and even bare metal. 
    - A public is managed by a public cloud provider. 
    - Public cloud customers may share resources with other organizations.

2. Read about Region, Zone in AWS. What are they for, which one will you use?
  - Answers:  
    - Region is a physical location, where data centers are clustered.
    - Availability Zone is one or more discrete data centers.

3. Read about AWS EC2, what is it, what is it useful for?
  - Answer:  
    - EC2 provides computing capacity

4. Read about AWS VPC (SG, Route, Internet Gateway).
5. If you sign up in AWS for the first time, you will have the opportunity to use SOME AWS services for free (free tier) for 1 year. To register, you need a credit card from which it will be debited and returned 1-2$.
6. Read about AWS Free Tier. There should be a clear of what will be free for new users and what will have to be paid for your own money.



##Tasks:
==================================================

1. Sign up for AWS, familiarize yourself with the basic elements of the AWS Home Console GUI.
2. Explore AWS Billing for checking current costs. Create two EC2 Instance t2.micro with different operating systems (Amazon linux / Ubuntu ...). Try to stop them, restart, delete, recreate.
3. Make sure there is an SSH connection from your host to the created EC2. What IP EC2 used for it?
4. Make sure is an ping and SSH passed from one instance to another and vice versa. Configure SSH connectivity between instances using SSH keys.
5. Install web server (nginx/apache) to one instance; 
  - [x] Create [web page](http://3.127.35.180/) with text “Hello World” and information about OS version;
  - [x] Make sure web server accessible from internet and you can see your web page “Hello World” in your browser; 
  - [x] Make sure in instance without nginx/apache you can see “Hello world” from instance with nginx/apache.
 
##EXTRA:
=================================================

1. Run steps 3-5 with instances created in different VPC. (connectivity must be both external and internal IP)	
2. Write BASH script for installing web server (nginx/apache) and creating web pages with text “Hello World”, and information about OS version
3. Run step.6 without “manual” EC2 SSH connection.

**Bash script for second EXTRA task***
``` 
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
echo "<html><body bgcolor=blue><center><h2><p><font color=red>Hello Exadel DevOps World! OS version - AWS Linux</h2></center></body></html>" > /var/www/html/index.html
```

Link to the User Guide ["Run commands on your Linux instance at launch"](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)

Link to the [running instance](http://18.193.74.94/), configured by bash script

