provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "student-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "feedback_sg" {
  name_prefix = "feedback-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "feedback_app" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu 22.04 (example)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.feedback_sg.name]
  user_data = file("${path.module}/userdata.sh")
  tags = { Name = "StudentFeedbackApp" }
}

output "public_ip" {
  value = aws_instance.feedback_app.public_ip
}
