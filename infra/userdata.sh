#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io git openjdk-11-jdk

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Add your SSH public key to authorized_keys (important fix)
mkdir -p /home/ubuntu/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK8e5sc+HKlViFmG/NpWqpcAvFsM9uaiwIU8hanU9JI7 yashs@YASH" >> /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys

# Clone and run app
cd /home/ubuntu
git clone https://github.com/YASHSRIVASTAVA07/student-feedback.git
cd student-feedback/app
sudo docker build -t student-feedback-app .
sudo docker run -d -p 80:5000 student-feedback-app
