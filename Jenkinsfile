pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "student-feedback-app"
    }

    stages {
        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/YASHSRIVASTAVA07/student-feedback.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    // Stop and remove old container if exists
                    sh '''
                    docker stop student-feedback || true
                    docker rm student-feedback || true
                    docker run -d -p 5000:5000 --name student-feedback ${DOCKER_IMAGE}
                    '''
                }
            }
        }
    }
}
