pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'yashsrivastava07/student-feedback'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/YASHSRIVASTAVA07/student-feedback.git'
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:latest ./app'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-user', variable: 'USER'),
                                 string(credentialsId: 'dockerhub-pass', variable: 'PASS')]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE:latest'
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                sh 'ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@EC2_PUBLIC_IP "sudo docker pull $DOCKER_IMAGE:latest && sudo docker rm -f student-feedback || true && sudo docker run -d -p 5000:5000 --name student-feedback $DOCKER_IMAGE:latest"'
            }
        }
    }
}
