######################### VPC #########################
# vpc = 10.0.0.0/20
# public-subnet-a = 10.0.2.0/23
# public-subnet-c = 10.0.4.0/23
# private-subnet-a = 10.0.6.0/23
# private-subnet-c = 10.0.8.0/23

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dasc-vpc-main"
  }
}

################ Subnets #################
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "dasc-subnet-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % 2]

  tags = {
    Name = "dasc-subnet-private-${count.index + 1}"
  }
}

############# Internet Gateway ############
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dasc-igw-main"
  }
}

############# Route Tables ############
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "dasc-rt-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "dasc-rt-private"
  }
}

############# Route Tables association ############
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


################### security group #####################
######## Exam check Lambda 보안 그룹 ########
resource "aws_security_group" "lambda_examcheck" {
  name        = "dasc-sg-lambda-examcheck"
  description = "Security group for Lambda examcheck"
  vpc_id      = aws_vpc.main.id
##### 인바운드 규칙 (Ingress) #####
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
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

######### RDS 보안그룹 ##########
resource "aws_security_group" "rds" {
  name        = "dasc-sg-rds"
  description = "Security group for rds"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow MySQL inbound traffic from Lambda Security Group"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.dasc-sg-lambda-exam.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dasc-sg-rds"
  }

}