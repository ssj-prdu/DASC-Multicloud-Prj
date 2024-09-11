module "rdb" {
  source = "./rdb_infra"
  prefix = "dasc"


  subnet_ids             = aws_subnet.dasc-subnet-private[*].id
  vpc_security_group_ids = [aws_security_group.dasc-sg-rds.id]
  db_password            = var.db_password
}
