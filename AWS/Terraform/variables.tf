variable "region" {
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/20"
}

variable "availability_zones" {
  default = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/23", "10.0.2.0/23"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.4.0/23", "10.0.6.0/23"]
  }

variable "ami_id" {
  default = "ami-04a81a99f5ec58529"
}

variable "instance_type" {
  default = "t2.micro"
}


variable "domain_name" {
  default = "jhserver.store"
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}

################# output?? ########
