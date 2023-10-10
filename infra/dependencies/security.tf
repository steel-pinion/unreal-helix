resource "aws_security_group" "team_access" {
  lifecycle {
    create_before_destroy = true
  }

  name        = "team-ssh"
  description = "Allows team access to backend resources"
  vpc_id      = aws_vpc.steel.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound traffic"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # NOTE: you can specify your IP range here if you wish
    description = "allow ssh inbound"
  }

  tags = {
    Name = "team-ssh"
  }
}
