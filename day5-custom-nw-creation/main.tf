# Creation of VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom_vpc"
  }
}

resource "aws_subnet" "dev_subnet" {
  cidr_block = "10.0.0.0/24"
  vpc_id     = aws_vpc.custom_vpc.id
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "dev_igw"
  }
}

resource "aws_route_table" "dev_route_table" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }
}

resource "aws_route_table_association" "name" {
  # FIX: Changed from 'dev-subnet' to 'dev_subnet'
  subnet_id      = aws_subnet.dev_subnet.id
  route_table_id = aws_route_table.dev_route_table.id
}

resource "aws_security_group" "name" {
  name        = "dev_security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/10"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "name" {
  ami           = "ami-0d53cc9bd365ad65b"
  instance_type = "t3.micro"
  # FIX: Changed from 'subnet-1' to 'dev_subnet'
  subnet_id              = aws_subnet.dev_subnet.id
  vpc_security_group_ids = [aws_security_group.name.id]
}

