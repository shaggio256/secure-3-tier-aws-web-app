terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------------
# VPC
# -------------------------

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# -------------------------
# Availability Zones
# -------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

# -------------------------
# Internet Gateway
# -------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# -------------------------
# Public Subnets
# -------------------------

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-1"
    Tier = "public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-2"
    Tier = "public"
  }
}

# -------------------------
# Private Application Subnets
# -------------------------

resource "aws_subnet" "app_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-app-1"
    Tier = "application"
  }
}

resource "aws_subnet" "app_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-app-2"
    Tier = "application"
  }
}

# -------------------------
# Private Database Subnets
# -------------------------

resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-db-1"
    Tier = "database"
  }
}

resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.22.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-db-2"
    Tier = "database"
  }
}

# -------------------------
# Public Route Table
# -------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# -------------------------
# Private Application Route Tables
# -------------------------

resource "aws_route_table" "app_1" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-app-rt-1"
  }
}

resource "aws_route_table" "app_2" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-app-rt-2"
  }
}

resource "aws_route_table_association" "app_1" {
  subnet_id      = aws_subnet.app_1.id
  route_table_id = aws_route_table.app_1.id
}

resource "aws_route_table_association" "app_2" {
  subnet_id      = aws_subnet.app_2.id
  route_table_id = aws_route_table.app_2.id
}

# -------------------------
# Private Database Route Tables
# -------------------------

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-db-rt"
  }
}

resource "aws_route_table_association" "db_1" {
  subnet_id      = aws_subnet.db_1.id
  route_table_id = aws_route_table.db.id
}

resource "aws_route_table_association" "db_2" {
  subnet_id      = aws_subnet.db_2.id
  route_table_id = aws_route_table.db.id
}
