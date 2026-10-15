# =====================================================================
# NETWORK INFRASTRUCTURE (RESOURCES 1 - 7)
# =====================================================================

# 1. Virtual Private Cloud (VPC)
resource "aws_vpc" "rds_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "rds-architecture-vpc" }
}

# 2. Internet Gateway (Required for routing engine updates out of the VPC)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.rds_vpc.id
  tags   = { Name = "rds-architecture-igw" }
}

# 3. Private Subnet A (Houses Primary Database)
resource "aws_subnet" "subnet_private_a" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a" # <-- Change this from us-east-1a to us-west-2a
  tags              = { Name = "rds-private-subnet-a" }
}

# 4. Private Subnet B (Houses Read Replica)
resource "aws_subnet" "subnet_private_b" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b" # <-- Change this from us-east-1b to us-west-2b
  tags              = { Name = "rds-private-subnet-b" }
}

# 5. Route Table (For private network routing management)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.rds_vpc.id
  tags   = { Name = "rds-private-route-table" }
}

# 6. Route Table Association for Subnet A
resource "aws_route_table_association" "assoc_a" {
  subnet_id      = aws_subnet.subnet_private_a.id
  route_table_id = aws_route_table.private_rt.id
}

# 7. Route Table Association for Subnet B
resource "aws_route_table_association" "assoc_b" {
  subnet_id      = aws_subnet.subnet_private_b.id
  route_table_id = aws_route_table.private_rt.id
}

# =====================================================================
# DATABASE SETTINGS & ARCHITECTURE (RESOURCES 8 - 11)
# =====================================================================

# 8. Security Group (Filters database inbound network traffic)
resource "aws_security_group" "db_sg" {
  name        = "rds-database-sg"
  description = "Controls inbound traffic directly to the RDS cluster"
  vpc_id      = aws_vpc.rds_vpc.id

  # Allow inbound application connections over default PostgreSQL port 5432
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 9. DB Subnet Group (Combines subnets across AZs into an RDS target)
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rds-architecture-subnet-group"
  subnet_ids = [aws_subnet.subnet_private_a.id, aws_subnet.subnet_private_b.id]
  tags       = { Name = "rds-subnet-group" }
}

# 10. Primary RDS Database Instance
resource "aws_db_instance" "primary" {
  identifier             = "primary-postgres-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  
  db_name                = "productiondb"
  username               = "dbadmin"
  password               = var.db_password #self managed passward
  
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  
  # Change this from 7 to 1 to satisfy both the Free Tier and Replica rules:
  backup_retention_period = 1 
  
  skip_final_snapshot     = true
}
