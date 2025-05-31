resource "aws_instance" "web" {
  ami                    = "ami-0af9569868786b23a"
  instance_type          = "t2.micro"
  key_name               = "DevSecOps"
  vpc_security_group_ids = [aws_security_group.jenkins-vm-sg.id]
  user_data              = templatefile("./install.sh", {})

  tags = {
    Name = "Jenkins-SonarQube"
  }

  root_block_device {
    volume_size = 40
  }

}

resource "aws_security_group" "jenkins-vm-sg" {
  name        = "jenkins-vm-sg"
  description = "allow tls inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound-rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }

  ]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "jenkins-vm-sg"
  }

}
