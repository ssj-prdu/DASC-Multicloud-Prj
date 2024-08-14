resource "aws_db_instance" "dasc_rds" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  username             = "admin"
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = "my-dbsubnet-group"  # 이미 존재하는 DB 서브넷 그룹 이름을 사용
  vpc_security_group_ids = ["sg-xxxxxxxx"]    # 기존의 VPC 보안 그룹 ID를 사용

  tags = {
    Name = "dasc-rds"
  }
}
