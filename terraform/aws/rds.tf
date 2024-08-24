# resource "aws_db_subnet_group" "dasc_db_subnet_group" {
#   name       = "dasc-db-subnet-group"
#   description = "Subnet group for RDS instances"
#   subnet_ids = aws_subnet.dasc-subnet-private[*].id  # 프라이빗 서브넷의 ID를 모두 포함

#   tags = {
#     Name = "dasc-db-subnet-group"
#   }
# }

# resource "aws_db_parameter_group" "dasc_db_param_group" {
#   name   = "dasc-dev-test-param-group"
#   family = "mysql8.0"  # MySQL 버전에 따라 수정 필요
#   description = "Parameter group for Dev/Test environments"

#   tags = {
#     Name = "dasc-dev-test-param-group"
#   }
# }

# resource "aws_db_instance" "dasc_rds" {
#   identifier           = "dasc-rds"
#   engine               = "mysql"
#   instance_class       = "db.t3.micro"
#   allocated_storage    = 20
#   db_name              = "exam_system"
#   username             = "admin"
#   password             = var.db_password
#   db_subnet_group_name = aws_db_subnet_group.dasc_db_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.dasc-sg-rds.id]  # 관련된 보안 그룹 참조
#   multi_az             = true  # Multi-AZ 배포 활성화
#   monitoring_interval  = 60    # Enhanced Monitoring을 60초 간격으로 활성화
#   monitoring_role_arn  = aws_iam_role.rds_monitoring_role.arn  # 모니터링을 위한 IAM 역할
#   parameter_group_name = aws_db_parameter_group.dasc_db_param_group.name  # 파라미터 그룹 참조
#   skip_final_snapshot  = true

#   tags = {
#     Name = "dasc-rds"
#   }
# }

# resource "aws_iam_role" "rds_monitoring_role" {
#   name = "rds-monitoring-role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "monitoring.rds.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "rds_monitoring_role_policy" {
#   role       = aws_iam_role.rds_monitoring_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
# }


# # ################ 테이블 생성 ##############
# # resource "null_resource" "setup_db" {
# #   provisioner "local-exec" {
# #     command = <<EOT
# # mysql --host=${aws_db_instance.dasc_rds.endpoint} --user=admin --password=${var.db_password} --database=exam_system <<EOF
# # CREATE TABLE User (
# #     email VARCHAR(255) PRIMARY KEY,
# #     user_name VARCHAR(100) NOT NULL,
# #     user_password VARCHAR(255) NOT NULL,
# #     subscription_date DATE NOT NULL
# # );

# # CREATE TABLE Subject (
# #     exam_code CHAR(12) PRIMARY KEY,
# #     subject_name VARCHAR(100) NOT NULL,
# #     application_start DATE NOT NULL,
# #     application_end DATE NOT NULL,
# #     test_date DATE NOT NULL
# # );

# # INSERT INTO Subject (exam_code, subject_name, application_start, application_end, test_date) VALUES
# #     ('saa-c03', 'AWS Certified Solutions Architect', '2024-08-01', '2024-08-03', '2024-09-01'),
# #     ('sap-c02', 'AWS Certified Solutions Architect - Professional', '2024-08-04', '2024-08-06', '2024-09-07');

# # CREATE TABLE Exam_q (
# #     question_id VARCHAR(12) PRIMARY KEY,
# #     exam_code CHAR(12) NOT NULL,
# #     content VARCHAR(800) NOT NULL,
# #     A VARCHAR(500) NOT NULL,
# #     B VARCHAR(500) NOT NULL,
# #     C VARCHAR(500) NOT NULL,
# #     D VARCHAR(500) NOT NULL,
# #     answer CHAR(1) NOT NULL,
# #     FOREIGN KEY (exam_code) REFERENCES Subject(exam_code)
# # );

# # CREATE TABLE Candidate (
# #     exam_id INT(10) AUTO_INCREMENT PRIMARY KEY,
# #     email VARCHAR(255) NOT NULL,
# #     user_name VARCHAR(100) NOT NULL,
# #     exam_code CHAR(12),
# #     score INT,
# #     Pass_Fail ENUM('합격', '불합격'),
# #     test_date DATE NOT NULL,
# #     FOREIGN KEY (email) REFERENCES User(email),
# #     FOREIGN KEY (exam_code) REFERENCES Subject(exam_code)
# # );

# # ALTER TABLE Candidate AUTO_INCREMENT = 1000000000;
# # EOF
# # EOT
# #   }

# #   depends_on = [aws_db_instance.dasc_rds]  # RDS 인스턴스 생성 후에 스크립트 실행
# # }
