variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "google_credentials" {
  type = string
}


variable "vpc" {
  type = string
  default = "dasc-vpc-main"
}

variable "subnet-main" {
  type = string
  default = "mainsubnet"
}