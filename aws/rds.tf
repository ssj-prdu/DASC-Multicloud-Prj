resource "aws_db_subnet_group" "dasc_db_subnet_group" {
  name       = "dasc-db-subnet-group"
  description = "Subnet group for RDS instances"
  subnet_ids = aws_subnet.dasc-subnet-private[*].id  # 프라이빗 서브넷의 ID를 모두 포함

  tags = {
    Name = "dasc-db-subnet-group"
  }
}

resource "aws_db_instance" "dasc_rds" {
  identifier           = "dasc-db"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "mydatabase"
  username             = "admin"
  password             = "password123"
  db_subnet_group_name = aws_db_subnet_group.dasc_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]  # 관련된 보안 그룹 참조
  skip_final_snapshot  = true

  tags = {
    Name = "dasc-rds"
  }
}
