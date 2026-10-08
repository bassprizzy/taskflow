resource "aws_vpc" "taskflow" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "taskflow-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.taskflow.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "taskflow-public-subnet"
  }
}

resource "aws_internet_gateway" "taskflow" {
  vpc_id = aws_vpc.taskflow.id

  tags = {
    Name = "taskflow-internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.taskflow.id

  tags = {
    Name = "taskflow-public-route-table"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.taskflow.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.taskflow.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "taskflow-private-subnet"
  }
}

resource "aws_security_group" "ec2" {
  name        = "taskflow-ec2-sg"
  description = "Security group for TaskFlow EC2"
  vpc_id      = aws_vpc.taskflow.id

  tags = {
    Name = "taskflow-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_ssh" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ec2_http" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ec2_https" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_security_group" "rds" {
  name        = "taskflow-rds-sg"
  description = "Security group for TaskFlow PostgreSQL RDS"
  vpc_id      = aws_vpc.taskflow.id

  tags = {
    Name = "taskflow-rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_postgres" {
  security_group_id = aws_security_group.rds.id

  referenced_security_group_id = aws_security_group.ec2.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"
}
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.taskflow.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "taskflow-private-subnet-2"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_db_subnet_group" "taskflow" {
  name = "taskflow-db-subnet-group"

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "taskflow-db-subnet-group"
  }
}

resource "aws_db_instance" "taskflow" {
  identifier = "taskflow-postgres"

  engine         = "postgres"
  engine_version = "14"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "taskflow"
  username = "postgres"
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.taskflow.name
  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  tags = {
    Name = "taskflow-postgres"
  }
}