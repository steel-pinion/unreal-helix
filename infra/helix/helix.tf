data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "helix" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.micro"

  key_name                    = "helix"
  iam_instance_profile        = "ec2-jump"
  subnet_id                   = data.aws_subnets.public.ids[0]
  security_groups             = [aws_security_group.ec2_helix.id, data.aws_security_group.team_ssh.id]
  associate_public_ip_address = true
  monitoring                  = false


  credit_specification {
    cpu_credits = "unlimited"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = false
  }

  tags = {
    Name = var.project
  }
}
