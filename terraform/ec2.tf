# Find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Application Server 1
resource "aws_instance" "app1" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.app_1.id

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  tags = {
    Name = "app-server-1"
  }
}

# Application Server 2
resource "aws_instance" "app2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  subnet_id = aws_subnet.app_2.id

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  tags = {
    Name = "app-server-2"
  }
}
