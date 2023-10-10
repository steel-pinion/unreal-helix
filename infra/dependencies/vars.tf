variable "project" {
  default = ""
}

variable "project_code" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}

variable "environment" {
  default = "lab"
}

terraform {
  required_version = ">= 1.0.5"
  backend "s3" {
    acl    = "private"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.region
}
