resource "aws_db_subnet_group" "dasc_db_subnet_group" {
  name       = "dasc-db-subnet-group"
  description = "Subnet group for RDS instances"
  subnet_ids = aws_subnet.dasc-subnet-private[*].id  # 프라이빗 서브넷의 ID를 모두 포함

  tags = {
    Name = "dasc-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "dasc_db_param_group" {
  name   = "dasc-dev-test-param-group"
  family = "mysql8.0"  # MySQL 버전에 따라 수정 필요
  description = "Parameter group for Dev/Test environments"

  tags = {
    Name = "dasc-dev-test-param-group"
  }
}

resource "aws_db_instance" "dasc_rds" {
  identifier           = "dasc-rds"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "exam_system"
  username             = "admin"
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.dasc_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.dasc-sg-rds.id]  # 관련된 보안 그룹 참조
  multi_az             = true  # Multi-AZ 배포 활성화
  monitoring_interval  = 60    # Enhanced Monitoring을 60초 간격으로 활성화
  monitoring_role_arn  = aws_iam_role.rds_monitoring_role.arn  # 모니터링을 위한 IAM 역할
  parameter_group_name = aws_db_parameter_group.dasc_db_param_group.name  # 파라미터 그룹 참조
  skip_final_snapshot  = true

  tags = {
    Name = "dasc-rds"
  }
}
