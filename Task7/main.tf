# Add ssh key
resource "aws_key_pair" "ssh-key" {
  key_name   = var.ec2_key_name
  public_key = "${file(var.public_key_location)}"
}

# Create Security Group - ZabbixServer
resource "aws_security_group" "zabbix-server" {
  vpc_id      = aws_vpc.vpc.id
  name        = "Zabbix-Server"
  description = "Security Group for the Zabbix Server."

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.my_ip
  }
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.zabbix_access_allowed_ip_addresses
  }
  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = var.zabbix_access_allowed_ip_addresses
  }
  ingress {
    protocol    = "tcp"
    from_port   = 10050
    to_port     = 10051
    cidr_blocks = var.zabbix_service_allowed_ip_addresses
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] # service can communitcate out withou restrictions, change it if needed
  }

  tags = {
    Name: "${var.env_prefix}-zabbixserver"
    Application = "Zabbix Server"
  } 
}
# Create EC2 Instance - ZabbixServer
resource "aws_instance" "instance-zabbix-server" {
  instance_type               = var.instance_type
  ami                         = var.ec2_image_id
  vpc_security_group_ids      = [aws_security_group.zabbix-server.id]
  subnet_id                   = aws_subnet.public-subnet-1.id
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  # user_data                   = file("install-zabbix.sh")
#   connection {
#     type = "ssh"
#     host = self.public_ip
#     user = "ubuntu"
#     private_key = "${file(var.private_key_location)}"
# }

#   provisioner "file" {
#     source = "install-zabbix.sh"
#     destination = "/home/ubuntu/install-zabbix.sh"
#   }


  tags = {
    Name: "${var.env_prefix}-vpc"
    Application = "Zabbix Server"
  }
}

resource "aws_instance" "instance-zabbix-server2" {
  instance_type               = var.instance_type
  ami                         = var.ec2_image_id
  vpc_security_group_ids      = [aws_security_group.zabbix-server.id]
  subnet_id                   = aws_subnet.public-subnet-1.id
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  # user_data                   = file("install-zabbix.sh")
#   connection {
#     type = "ssh"
#     host = self.public_ip
#     user = "ubuntu"
#     private_key = "${file(var.private_key_location)}"
# }

#   provisioner "file" {
#     source = "install-zabbix.sh"
#     destination = "/home/ubuntu/install-zabbix.sh"
#   }


  tags = {
    Name: "${var.env_prefix}-agent"
    Application = "Zabbix Server"
  }
}

# Create EIP for EC2 Instance ZabbixServer
resource "aws_eip" "eip-instance-zabbix-server" {
  # count = 1
  instance = aws_instance.instance-zabbix-server.id
  vpc = true
}

# Output
output "zabbixserver-ip" {
  value = aws_eip.eip-instance-zabbix-server.public_ip
}

# End;