data "aws_caller_identity" "current" {}

data "aws_vpc" "steel" {
  filter {
    name   = "tag:Name"
    values = ["steel-vpc"]
  }
}

data "aws_subnets" "public" {

  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.steel.id ]
  }

  filter {
    name = "tag:For"
    values = [ "public" ]
  }
}

data "aws_security_group" "team_ssh" {
  filter {
    name   = "tag:Name"
    values = ["team-ssh"]
  }
}
