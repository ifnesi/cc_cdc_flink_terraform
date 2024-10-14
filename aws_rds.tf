provider "aws" {
  region = var.aws_rds_region
}

# AWS Availability Zones data
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "zone-type"
    values = ["availability-zone"]  # Filters only for standard AZs
  }
}
output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

# Create the VPC
resource "aws_vpc" "rds-vpc" {
  cidr_block           = var.rds_vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name       = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-vpc"
    created_by = "terraform"
  }
}

# Create the RDS Oracle Subnet AZ1
resource "aws_subnet" "rds-subnet-az1" {
  vpc_id            = aws_vpc.rds-vpc.id
  cidr_block        = var.rds_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name       = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-subnet-az1"
    created_by = "terraform"
  }
}

# Create the RDS Oracle Subnet AZ2
resource "aws_subnet" "rds-subnet-az2" {
  vpc_id            = aws_vpc.rds-vpc.id
  cidr_block        = var.rds_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name       = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-subnet-az2"
    created_by = "terraform"
  }
}

# Create the RDS Oracle Subnet Group
resource "aws_db_subnet_group" "rds-subnet-group" {
  name       = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-subnet-group"
  subnet_ids = [aws_subnet.rds-subnet-az1.id, aws_subnet.rds-subnet-az2.id]

  depends_on = [
    aws_subnet.rds-subnet-az1,
    aws_subnet.rds-subnet-az2,
  ]

  tags = {
    Name       = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-subnet-group"
    created_by = "terraform"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "rds-igw" {
  vpc_id = aws_vpc.rds-vpc.id

  tags = {
    Name       = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-igw"
    created_by = "terraform"
  }
}

# Define the RDS Oracle route table to Internet Gateway
resource "aws_route_table" "rds-rt-igw" {
  vpc_id = aws_vpc.rds-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rds-igw.id
  }

  tags = {
    Name       = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-public-route-igw"
    created_by = "terraform"
  }
}

# Assign the Oracle RDS route table to the RDS Subnet az1 for IGW 
resource "aws_route_table_association" "rds-subnet-rt-association-igw-az1" {
  subnet_id      = aws_subnet.rds-subnet-az1.id
  route_table_id = aws_route_table.rds-rt-igw.id
}

# Assign the public route table to the RDS Subnet az2 for IGW 
resource "aws_route_table_association" "rds-subnet-rt-association-igw-az2" {
  subnet_id      = aws_subnet.rds-subnet-az2.id
  route_table_id = aws_route_table.rds-rt-igw.id
}

resource "aws_security_group" "rds_security_group" {
  name        = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-security-group"
  description = "Security Group for RDS Oracle instance. Used in Confluent Cloud Database Modernization workshop."
  vpc_id      = aws_vpc.rds-vpc.id

  ingress {
    description = "RDS Oracle Port"
    from_port   = 1521
    to_port     = 1521
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name       = "${var.rds_instance_identifier}-${random_id.id.hex}-rds-security-group"
    created_by = "terraform"
  }
}

resource "aws_db_instance" "default" {
  identifier             = "${var.rds_instance_identifier}-${random_id.id.hex}"
  engine                 = "oracle-se2"
  engine_version         = "19"
  instance_class         = var.rds_instance_class
  username               = var.rds_username
  password               = var.rds_password
  port                   = 1521
  license_model          = "license-included"
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  #   parameter_group_name = "default.oracle-se2-19.0"
  allocated_storage   = 20
  storage_encrypted   = false
  skip_final_snapshot = true
  publicly_accessible = true
  tags = {
    name       = "${var.rds_instance_identifier}-${random_id.id.hex}"
    created_by = "terraform"
  }
}
output "default" {
  value     = aws_db_instance.default
  sensitive = true
}