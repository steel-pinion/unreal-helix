resource "aws_vpc" "steel" {
  cidr_block           = "172.39.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "steel-vpc"
  }
}

resource "aws_subnet" "a" {
  vpc_id            = aws_vpc.steel.id
  cidr_block        = "172.39.0.0/20"
  availability_zone = "${var.region}a"

  tags = {
    Name = "steel-vpc-${var.region}a"
    For  = "public"
  }
}

resource "aws_subnet" "b" {
  vpc_id            = aws_vpc.steel.id
  cidr_block        = "172.39.16.0/20"
  availability_zone = "${var.region}b"

  tags = {
    Name = "steel-vpc-${var.region}b"
    For  = "public"
  }
}

resource "aws_subnet" "c" {
  vpc_id            = aws_vpc.steel.id
  cidr_block        = "172.39.32.0/20"
  availability_zone = "${var.region}c"

  tags = {
    Name = "steel-vpc-${var.region}c"
    For  = "public"
  }
}

resource "aws_subnet" "d" {
  vpc_id            = aws_vpc.steel.id
  cidr_block        = "172.39.48.0/20"
  availability_zone = "${var.region}d"

  tags = {
    Name = "steel-vpc-${var.region}d"
    For  = "public"
  }
}

resource "aws_db_subnet_group" "public" {
  name       = "public-subnet"
  subnet_ids = [aws_subnet.a.id, aws_subnet.b.id, aws_subnet.c.id, aws_subnet.d.id]

  tags = {
    Name = "Generic public subnet for data-api enabled databases"
  }
}

resource "aws_internet_gateway" "steel" {
  vpc_id = aws_vpc.steel.id

  tags = {
    Name = "steel"
  }
}
