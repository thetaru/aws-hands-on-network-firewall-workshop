# Security Group
resource "aws_security_group" "Webserver_Security_Group" {
  name        = "WebServer Security Group"
  vpc_id      = aws_vpc.Inspection_VPC.id
}

resource "aws_vpc_security_group_ingress_rule" "WebServer_Security_Group_Ingress_Rule" {
  security_group_id = aws_security_group.Webserver_Security_Group.id
  cidr_ipv4   = "10.0.0.0/8"
  ip_protocol = "icmp"
  from_port   = -1
  to_port     = -1
}

resource "aws_vpc_security_group_egress_rule" "VPC_A_Security_Group_Egress_Rule" {
  security_group_id = aws_security_group.Webserver_Security_Group.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  from_port   = -1
  to_port     = -1
}
