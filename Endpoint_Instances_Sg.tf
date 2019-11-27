resource "aws_instance" "Endpoint_1" {
  ami             = "ami-00f8336af4b6b40bf"
  instance_type   = "t3.xlarge"
  subnet_id     = "${aws_subnet.Endpoint_Public.id}"
  associate_public_ip_address="true"
  vpc_security_group_ids = ["${aws_security_group.my_pc.id}"]
  
  key_name = "sqlireland"
  tags = {
			Name = "Endpoint_1"
			}

}

  resource "aws_instance" "Endpoint_2" {
  ami             = "ami-00f8336af4b6b40bf"
  instance_type   = "t3.xlarge"
  subnet_id     = "${aws_subnet.Endpoint_Private.id}"
  vpc_security_group_ids = ["${aws_security_group.my_pc.id}"]
  key_name = "sqlireland"
  tags = {
			Name = "Endpoint_2"
			}

}

resource "aws_security_group" "my_pc" {
  name        = "allow_traffic_my_computer"
  description = "allow_traffic_my_computer"
  vpc_id      = "${aws_vpc.Endpoint_VPC.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["14.98.201.90/32"] # add a CIDR block here
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    
  }

ingress {

    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["14.98.201.90/32"]    
  }

ingress {

    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["14.98.201.90/32"]    
  }

  ingress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]    
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}