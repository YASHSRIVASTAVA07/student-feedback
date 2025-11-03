provider "aws" {
  region = var.region
}

# ------------------------------
# Upload your local SSH key to AWS (Windows-safe path)
# ------------------------------
resource "aws_key_pair" "yash_local_key" {
  key_name   = "yash-local-ed25519"
  public_key = file("C:\\Users\\yashs\\.ssh\\id_ed25519.pub")
}

# ------------------------------
# Security Group
# ------------------------------
resource "aws_security_group" "student_app_sg" {
  name        = "student-app-sg"
  description = "Allow SSH, HTTP, and Jenkins access"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "student-feedback-sg"
  }
}

# ------------------------------
# EC2 Instance
# ------------------------------
resource "aws_instance" "student_app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.yash_local_key.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.student_app_sg.id]
  associate_public_ip_address = true

  # User data ensures key injection (with delay for cloud-init)
  user_data = <<-EOF
              #!/bin/bash
              mkdir -p /home/ubuntu/.ssh
              echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8e5sc+HKlViFmG/NpWqpcAvFsM9uaiwIU8hanU9JI7 yashs@YASH" >> /home/ubuntu/.ssh/authorized_keys
              sleep 10
              chown -R ubuntu:ubuntu /home/ubuntu/.ssh
              chmod 700 /home/ubuntu/.ssh
              chmod 600 /home/ubuntu/.ssh/authorized_keys
              EOF

  tags = {
    Name = "student-feedback-instance"
  }
}

# ------------------------------
# Outputs
# ------------------------------
output "instance_id" {
  value = aws_instance.student_app.id
}

output "instance_public_ip" {
  value = aws_instance.student_app.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.student_app.public_ip}:8080"
}

output "public_ip" {
  value = aws_instance.student_app.public_ip
}
