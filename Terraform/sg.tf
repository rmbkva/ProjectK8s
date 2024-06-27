resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.my.id


    ingress {
    description      = "TLS from VPC"
    from_port        = var.ports[0]
    to_port          = var.ports[0]
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/24"]
  }

    ingress {
    description      = "TLS from VPC"
    from_port        = var.ports[1]
    to_port          = var.ports[1]
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}