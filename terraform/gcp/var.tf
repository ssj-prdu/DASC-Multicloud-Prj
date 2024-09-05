variable "project_id" {
  type = string
}

variable "region" {
  type = string
  default = "asia-northeast3"
}

variable "credentials_file" {
  type = string
}

variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
  default = "mainsubnet"
}
