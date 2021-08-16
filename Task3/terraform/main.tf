# Configure provider AWS, with region eu-west-1
provider "aws" {
    region = "eu-west-1"
}

# Define the variables

variable vpc_cidr_block {} 
variable subnet_cidr_block {} 
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable public_key_location {}
variable private_key_location {}
variable proxy_port {}

# Create a vpc resource with the custom cidr block range of 10.0.0.0/16  

resource "aws_vpc" "exadel-devops" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}

# Create a subnet resource with the custom cidr block range of 10.0.10.0/24 named by "eu-west-1a"   

resource "aws_subnet" "exadel-devops-subnet-1" {
    vpc_id = aws_vpc.exadel-devops.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"   
    }
}

# Create a vpc route and gateway
resource "aws_internet_gateway" "exadel-devops-igw" {
    vpc_id = aws_vpc.exadel-devops.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

resource "aws_route_table" "exadel-devops-route-table" {
    vpc_id = aws_vpc.exadel-devops.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.exadel-devops-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}
# Create route table assosiation with the exadel-devops-route-table

resource "aws_route_table_association" "as-exdev-route-table" {
    subnet_id = aws_subnet.exadel-devops-subnet-1.id
    route_table_id = aws_route_table.exadel-devops-route-table.id
}

resource "aws_security_group" "exadel-devops-sg" {
    name = "exadel-devops-sg"
    vpc_id = aws_vpc.exadel-devops.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8
        to_port = 0
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    ingress {
        from_port   = var.proxy_port
        to_port     = var.proxy_port
        protocol    = "tcp"
        cidr_blocks = ["${self.private_ip}/32"]
    }

    tags = {
        Name: "${var.env_prefix}-sg"
    }
}

# Fetch data from AWS

data "aws_ami" "latest-amazon-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_ami" "latest-ubuntu-image" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name = "name"
        values = ["ubuntu-*-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

# Output 

output "aws_ami_amazone" {
    value = data.aws_ami.latest-amazon-image.id
}

output "aws_ami_ubuntu" {
    value = data.aws_ami.latest-ubuntu-image.id
}

output "ec2_public_ip" {
    value = aws_instance.aws-ubuntuserver.public_ip
    description = "Public IP address of the proxy server"
}

output "proxy_port" {
  value       = var.proxy_port
  description = "Port of the proxy server"
}
# Creating a key pair

resource "aws_key_pair" "ssh-key" {
    key_name = "ssh-server-key"
    public_key = "${file(var.public_key_location)}"
}

#  Creating an EC2 instance with Ubuntu image

resource "aws_instance" "aws-ubuntuserver" {
    ami = data.aws_ami.latest-ubuntu-image.id
    instance_type = var.instance_type
    
    subnet_id = aws_subnet.exadel-devops-subnet-1.id
    vpc_security_group_ids = [aws_security_group.exadel-devops-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.key_name

    
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = file(var.private_key_location)
    }

    provisioner "file" {
        source = "entry-script.sh"
        destination = "/home/ubuntu/entry-script.sh"
    }
    provisioner "file" {
        source = "proxy.sh"
        destination = "/home/ubuntu/proxy.sh"
    }

    provisioner "remote-exec" {
        scripts = ["entry-script.sh", "proxy.sh"]
    }

    tags =  {
        Name: "${var.env_prefix}-ubuntuserver"
        Proxy = "${var.env_prefix}-tinyproxy"
    }
}

#  Creating an EC2 instance with Amazone Linux image

resource "aws_instance" "aws-amazoneserver" {
    ami = data.aws_ami.latest-amazon-image.id
    instance_type = var.instance_type
    
    subnet_id = aws_subnet.exadel-devops-subnet-1.id
    vpc_security_group_ids = [aws_security_group.exadel-devops-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = "false"
    key_name = aws_key_pair.ssh-key.key_name

    #user_data = file("entry-script.sh")

    tags =  {
        Name: "${var.env_prefix}-amazoneserver"
    }
}

