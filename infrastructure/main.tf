provider "aws" {
  region = var.region
}

## EC2 Instance
resource "aws_instance" "StrongSwanVPN_webserver" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name = var.key_pair
  subnet_id = aws_subnet.StrongSwanVPN_subnet.id
  vpc_security_group_ids  = [aws_security_group.StrongSwanVPN_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = join("_", [var.base_prefix, "server_instance"])
    Project = var.base_prefix
  }
}

resource "aws_instance" "StrongSwanVPN_testclient" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name = var.key_pair
  subnet_id = aws_subnet.StrongSwanVPN_subnet.id
  vpc_security_group_ids  = [aws_security_group.StrongSwanVPN_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = join("_", [var.base_prefix, "client_instance"])
    Project = var.base_prefix
  }
}

## AWS Virtual Private Cloud

resource "aws_vpc" "StrongSwanVPN_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = join("_", [var.base_prefix, "vpc"])
    Project = var.base_prefix
  }
}


resource "aws_internet_gateway" "StrongSwanVPN_ig" {
  vpc_id = aws_vpc.StrongSwanVPN_vpc.id

  tags = {
    Name = join("_", [var.base_prefix, "ig"])
    Project = var.base_prefix
  }
}


resource "aws_subnet" "StrongSwanVPN_subnet" {
  vpc_id     = aws_vpc.StrongSwanVPN_vpc.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = join("_", [var.base_prefix, "subnet"])
    Project = var.base_prefix
  }
}

resource "aws_route_table" "StrongSwanVPN_route_table" {
  vpc_id = aws_vpc.StrongSwanVPN_vpc.id

  tags = {
    Name = join("_", [var.base_prefix, "route_table"])
    Project = var.base_prefix
  }
}

resource "aws_route" "StrongSwanVPN_route" {
  route_table_id         = aws_route_table.StrongSwanVPN_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.StrongSwanVPN_ig.id
}


resource "aws_route_table_association" "StrongSwanVPN_rt_association" {
  subnet_id      = aws_subnet.StrongSwanVPN_subnet.id
  route_table_id = aws_route_table.StrongSwanVPN_route_table.id
}



### Security Group (AWS Firewall)
resource "aws_security_group" "StrongSwanVPN_sg" {
  name = join("_", [var.base_prefix, "sg"])
  description = "For the StrongSwanVPN Instance"
  vpc_id      = aws_vpc.StrongSwanVPN_vpc.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_ipv4_cidr_1
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_1
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.ingress_ipv4_cidr_1
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_1
  }

  ingress {
    description = "weird https"
    from_port   = 4443
    to_port     = 4443
    protocol    = "tcp"
    cidr_blocks = var.ingress_ipv4_cidr_1
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_1
  }


  ingress {
    description = "StrongSwan: charon port"
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = var.ingress_ipv4_cidr_1
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_1
  }

  ingress {
    description = "StrongSwan: charon port_nat_t"
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = var.ingress_ipv4_cidr_1
    ipv6_cidr_blocks = var.ingress_ipv6_cidr_1
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_ipv4_cidr_2
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = join("_", [var.base_prefix, "sg"])
    Project = var.base_prefix
  }
}