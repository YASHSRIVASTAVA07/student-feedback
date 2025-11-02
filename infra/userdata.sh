#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker
docker pull yashsrivastava07/student-feedback:latest
docker rm -f student-feedback || true
docker run -d -p 5000:5000 --name student-feedback yashsrivastava07/student-feedback:latest
