# Network Interface
resource "aws_network_interface" "WebServer_ENI" {
  subnet_id       = aws_subnet.Inspection_VPC_Protected_Workload_Subnet.id
  private_ips     = ["10.1.3.4"]
  security_groups = [aws_security_group.Webserver_Security_Group.id]
}

# Elastic IP
resource "aws_eip" "WebServer_EIP" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.WebServer_ENI.id
  associate_with_private_ip = "10.1.3.4"
}

# EC2 Instance
resource "aws_instance" "WebServer" {
  ami                  = "ami-013a28d7c2ea10269"
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.WebServerEC2InstanceProfile.name

  network_interface {
    network_interface_id = aws_network_interface.WebServer_ENI.id
    device_index         = 0
  }

  tags = {
    Name = "WebServer"
  }
}
