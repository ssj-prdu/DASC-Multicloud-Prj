######################### VPC #########################
# vpc = 10.0.0.0/20
# public-subnet-a = 10.0.2.0/23
# public-subnet-c = 10.0.4.0/23
# private-subnet-a = 10.0.6.0/23
# private-subnet-c = 10.0.8.0/23

resource "aws_vpc" "dasc-vpc-main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dasc-vpc-main"
  }
}

################ Subnets #################
resource "aws_subnet" "dasc-subnet-public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.dasc-vpc-main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "dasc-subnet-public-${count.index + 1}"
  }
}

resource "aws_subnet" "dasc-subnet-private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.dasc-vpc-main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % 2]

  tags = {
    Name = "dasc-subnet-private-${count.index + 1}"
  }
}

############# Internet Gateway ############
resource "aws_internet_gateway" "aws-igw-main" {
  vpc_id = aws_vpc.dasc-vpc-main.id

  tags = {
    Name = "dasc-igw-main"
  }
}

############# Route Tables ############
resource "aws_route_table" "dasc-rt-public" {
  vpc_id = aws_vpc.dasc-vpc-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws-igw-main.id
  }

  tags = {
    Name = "dasc-rt-public"
  }
}

resource "aws_route_table" "dasc-rt-private" {
  vpc_id = aws_vpc.dasc-vpc-main.id

  tags = {
    Name = "dasc-rt-private"
  }
}

############# Route Tables association ############
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.dasc-subnet-public)
  subnet_id      = aws_subnet.dasc-subnet-public[count.index].id
  route_table_id = aws_route_table.dasc-rt-public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.dasc-subnet-private)
  subnet_id      = aws_subnet.dasc-subnet-private[count.index].id
  route_table_id = aws_route_table.dasc-rt-private.id
}


############# security group ############
# RDS 보안 그룹
resource "aws_security_group" "rds_sg" {
  name        = "dasc-sg-rds"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.dasc-vpc-main.id  # 사용 중인 VPC의 ID로 대체하세요.

  # Lambda에서 RDS로 접근을 허용
  ingress {
    from_port   = 3306  # MySQL의 경우 3306, PostgreSQL의 경우 5432
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]  # Lambda 보안 그룹에서 접근 허용
  }

  # 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dasc-sg-rds"
  }
}

# Lambda 보안 그룹
resource "aws_security_group" "lambda_sg" {
  name        = "dasc-sg-lambda-exam"
  description = "Security group for Lambda examcheck"
  vpc_id      = aws_vpc.dasc-vpc-main.id  # 사용 중인 VPC의 ID로 대체하세요.

  # Lambda에서 RDS로의 접근을 허용
  egress {
    from_port       = 3306  # RDS의 포트와 일치해야 합니다.
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.rds_sg.id]
  }

  # Lambda에서 API Gateway로의 접근을 허용 (보통 HTTP/HTTPS)
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Lambda가 외부 API나 서비스에 접근할 수 있도록 모든 아웃바운드 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dasc-sg-lambda-exam"
  }
}
