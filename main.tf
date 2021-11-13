provider "aws" {}

# VPC
resource "aws_vpc" "TheDivineMedSpa-VPC" {
  cidr_block           = "192.168.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "TheDivineMedSpa-VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "TheDivineMedSpa-gw" {
  vpc_id = aws_vpc.TheDivineMedSpa-VPC.id

  tags = {
    Name = "TheDivineMedSpa-gw"
  }
}

# Route Tables
resource "aws_route_table" "TheDivineMedSpa-rt-1" {
  vpc_id = aws_vpc.TheDivineMedSpa-VPC.id
  route = [{
    cidr_block                 = "0.0.0.0/0"
    gateway_id                 = aws_internet_gateway.TheDivineMedSpa-gw.id
    instance_id                = null
    ipv6_cidr_block            = null
    carrier_gateway_id         = null
    destination_prefix_list_id = null
    egress_only_gateway_id     = null
    local_gateway_id           = null
    nat_gateway_id             = null
    network_interface_id       = null
    transit_gateway_id         = null
    vpc_endpoint_id            = null
    vpc_peering_connection_id  = null
  }]

  tags = {
    Name = "TheDivineMedSpa-rt-1"
  }
}

# resource "aws_route_table" "TheDivineMedSpa-rt-2" {
#   vpc_id = aws_vpc.TheDivineMedSpa-VPC.id
#   route = [{
#     cidr_block                 = "192.168.1.0/24"
#     gateway_id                 = aws_internet_gateway.TheDivineMedSpa-gw.id
#     instance_id                = null
#     ipv6_cidr_block            = null
#     carrier_gateway_id         = null
#     destination_prefix_list_id = null
#     egress_only_gateway_id     = null
#     local_gateway_id           = null
#     nat_gateway_id             = null
#     network_interface_id       = null
#     transit_gateway_id         = null
#     vpc_endpoint_id            = null
#     vpc_peering_connection_id  = null
#   }]

#   tags = {
#     Name = "TheDivineMedSpa-rt-2"
#   }
# }

# Route Table Associations
resource "aws_route_table_association" "TheDivineMedSpa-rta-1" {
  route_table_id = aws_route_table.TheDivineMedSpa-rt-1.id
  subnet_id      = aws_subnet.TheDivineMedSpa-sb-1.id
}

# resource "aws_route_table_association" "TheDivineMedSpa-rta-2" {
#   subnet_id      = aws_subnet.TheDivineMedSpa-sb-private-1.id
#   route_table_id = aws_route_table.TheDivineMedSpa-rt-2.id
# }

# resource "aws_route_table_association" "TheDivineMedSpa-rta-3" {
#   subnet_id      = aws_subnet.TheDivineMedSpa-sb-private-2.id
#   route_table_id = aws_route_table.TheDivineMedSpa-rt-2.id
# }

# Subnets
resource "aws_subnet" "TheDivineMedSpa-sb-1" {
  vpc_id                  = aws_vpc.TheDivineMedSpa-VPC.id
  map_public_ip_on_launch = true
  cidr_block              = "192.168.0.0/25"
  availability_zone       = "us-west-1b"

  tags = {
    Name = "TheDivineMedSpa-sb-1"
  }
}

resource "aws_subnet" "TheDivineMedSpa-sb-private-1" {
  vpc_id            = aws_vpc.TheDivineMedSpa-VPC.id
  cidr_block        = "192.168.0.128/26"
  availability_zone = "us-west-1b"

  tags = {
    Name = "TheDivineMedSpa-sb-private-1"
  }
}

resource "aws_subnet" "TheDivineMedSpa-sb-private-2" {
  vpc_id            = aws_vpc.TheDivineMedSpa-VPC.id
  cidr_block        = "192.168.0.192/26"
  availability_zone = "us-west-1c"

  tags = {
    Name = "TheDivineMedSpa-sb-private-2"
  }
}

# Subnet Group
resource "aws_db_subnet_group" "TheDivineMedSpa-db-subnet-group-1" {
  name       = "main"
  subnet_ids = [aws_subnet.TheDivineMedSpa-sb-private-1.id, aws_subnet.TheDivineMedSpa-sb-private-2.id]

  tags = {
    Name = "TheDivineMedSpa-db-subnet-group-1"
  }
}

# Network Access Control List (Firewall)
resource "aws_network_acl" "TheDivineMedSpa-nacl" {
  vpc_id     = aws_vpc.TheDivineMedSpa-VPC.id
  subnet_ids = [aws_subnet.TheDivineMedSpa-sb-1.id]

  ingress = [{
    rule_no         = 100
    from_port       = 80
    to_port         = 80
    cidr_block      = "0.0.0.0/0"
    protocol        = "tcp"
    action          = "allow"
    icmp_code       = null
    icmp_type       = null
    ipv6_cidr_block = null

    }, {
    rule_no         = 200
    from_port       = 443
    to_port         = 443
    cidr_block      = "0.0.0.0/0"
    protocol        = "tcp"
    action          = "allow"
    icmp_code       = null
    icmp_type       = null
    ipv6_cidr_block = null

    }, {
    rule_no         = 300
    from_port       = 22
    to_port         = 22
    cidr_block      = "0.0.0.0/0"
    protocol        = "tcp"
    action          = "allow"
    icmp_code       = null
    icmp_type       = null
    ipv6_cidr_block = null
    }, {
    rule_no         = 400
    from_port       = 3389
    to_port         = 3389
    cidr_block      = "0.0.0.0/0"
    protocol        = "tcp"
    action          = "allow"
    icmp_code       = null
    icmp_type       = null
    ipv6_cidr_block = null
    }, {
    rule_no         = 500
    from_port       = 32768
    to_port         = 65535
    cidr_block      = "0.0.0.0/0"
    protocol        = "tcp"
    action          = "allow"
    icmp_code       = null
    icmp_type       = null
    ipv6_cidr_block = null
  }]

  egress = [{
    rule_no         = 100
    from_port       = 0
    to_port         = 0
    cidr_block      = "0.0.0.0/0"
    protocol        = -1
    action          = "allow"
    icmp_code       = null
    icmp_type       = null
    ipv6_cidr_block = null
  }]

  tags = {
    Name = "TheDivineMedSpa-nacl"
  }
}

# Security Groups
resource "aws_security_group" "TheDivineMedSpa-sg-1" {
  vpc_id      = aws_vpc.TheDivineMedSpa-VPC.id
  name        = "TheDivineMedSpa-sg-1"
  description = "Security Group for The Divine Med Spa. Allows all HTTP/SSH inbound traffic and HTTPS outbound traffic."

  # Inbound
  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
    }, {
    cidr_blocks      = ["192.168.1.128/26", "192.168.1.192/26"]
    description      = "DB from PostgreSQL RDS"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }]

  # Outbound
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "HTTP to VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
    }, {
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "HTTPS to VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
    }, {
    cidr_blocks      = ["192.168.1.128/26", "192.168.1.192/26"]
    description      = "DB to PostgreSQL RDS"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }]

  tags = {
    Name = "TheDivineMedSpa-sg-1"
  }
}

resource "aws_security_group" "TheDivineMedSpa-sg-2" {
  vpc_id      = aws_vpc.TheDivineMedSpa-VPC.id
  name        = "TheDivineMedSpa-sg-2"
  description = "Security Group for The Divine Med Spa. Allows all HTTP/SSH inbound traffic and HTTPS outbound traffic."

  # Inbound
  ingress = [{
    cidr_blocks      = ["192.168.1.128/26", "192.168.1.192/26"]
    description      = "Traffic from EC2"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }]

  # Outbound
  egress = [{
    cidr_blocks      = ["192.168.1.128/26", "192.168.1.192/26"]
    description      = "HTTPS to VPC"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    ipv6_cidr_blocks = null
    prefix_list_ids  = null
    security_groups  = null
    self             = null
  }]
}

resource "aws_db_parameter_group" "TheDivineMedSpa-db-pg" {
  name   = "rds-postgres"
  family = "postgres13"
}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2_instance_key_pair_thedivinemedspa"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+Ms8RPsugh2UXWJKC+dPY/b1qmEnOI65vaCbvwGUbH0xwPvrs2mKGKgesZTRsJibqyuGXEV+OuLxCa3lM/KO2KVW1y9wdnfEiahv1JZO7JB/lbjyQa6q491gLvOUOY7fN4E3xAJCJJWC7Rj7/rzN1tALWAE3YS1llgsKHiPfQxHjIRmisuoF9Leb3/TTNS5+CTqy4G/pAvxRK30vG7sTOzeGrnKXz7cr01dOo6JVeFF46WrYZgqLG1HYfvFSZe3OVyPrKF1MEQTndBrJu1Sy09yFajgOtJEDQr+nzcchfESUK9Tn56BpaU9CKHZf63QmieeYk0kOu/09Is5B5FKXfn3UqnQcE4F64SPpHoA7xz1VmbfjCQLRKx1lrNDTiVcdG0CqaKXbsMiSHMigkMcrjjzGO6dYPYtwUIUxGa4kY+wQKTLTJ8fHRYRl5IWlrawRYDGao+DnE1p5cnn62IZTUd1koj5w1qfiHYXkIBNZ6L/TyLvIQCp6kpattVKfNEZFZeYNtLPuc6zF8fb1OoQ/RxBR7Hi3mLB0CctLNI7ljRF3K7pK9v0rLZ9JP0+Ub30zrUu+apM819um4QRbBulr61noLfxrrmYZ8S3XZoBdSOzEXoUq2S+IVydnyTnKkkU4WDcfPQ7DEvW6BR6E5MU6gjWervb6Hq3eKcZJ+HLs2jQ== michael@orijinator.com"
}

# EC2 Instance
resource "aws_instance" "TheDivineMedSpa-web" {
  ami                         = "ami-04468e03c37242e1e"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.TheDivineMedSpa-sb-1.id
  vpc_security_group_ids      = [aws_security_group.TheDivineMedSpa-sg-1.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  user_data                   = file("./scripts/ec2-httpd.sh")

  tags = {
    Name = "TheDivineMedSpa-web"
  }
}

# Database
resource "aws_db_instance" "TheDivineMedSpa-db" {
  allocated_storage      = 5
  max_allocated_storage  = 100
  engine                 = "postgres"
  engine_version         = "13.2"
  instance_class         = "db.t3.micro"
  name                   = "strapiheadlessdb"
  username               = "main"
  password               = "Xh~b`=Db7X9;XeVw"
  parameter_group_name   = aws_db_parameter_group.TheDivineMedSpa-db-pg.name
  port                   = 5432
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.TheDivineMedSpa-sg-2.id]

  multi_az             = false
  db_subnet_group_name = aws_db_subnet_group.TheDivineMedSpa-db-subnet-group-1.name

  tags = {
    Name = "TheDivineMedSpa-db"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "TheDivineMedSpa-bucket" {
  bucket = "the-divine-med-spa"
  acl    = "private"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["https://thedivinemedspa.com"]
  }

  tags = {
    Name        = "TheDivineMedSpa-bucket"
    Environment = "Prod"
  }
}