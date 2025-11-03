pipeline {
    agent any

    stages {
        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/YASHSRIVASTAVA07/student-feedback.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t student-feedback-app .'
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh 'docker run -d -p 80:80 --name feedback student-feedback-app || true'
                }
            }
        }
    }
}
