resource "aws_security_group" "ec2_helix" {
  lifecycle {
    create_before_destroy = true
  }

  name        = "ec2-helix"
  description = "Allows team access to asset version control"
  vpc_id      = data.aws_vpc.steel.id

  ingress {
    from_port   = 1666
    to_port     = 1666
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow helix client inbound"
  }

  tags = {
    Name = "ec2-helix"
  }
}
