pipeline {
    agent any
    environment {
        APP_NAME = "myapp"
        DOCKER_IMAGE = "myapp-image"
    }
 
    stages {
 
        stage('Git Clone') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Amulya-dev-tech/POC_3.git'
            }
        }
 
        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
 
        stage('Docker Build') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE}:latest .
                """
            }
        }
 
        stage('Docker Run') {
            steps {
                sh """
                docker rm -f ${APP_NAME} || true
                docker run -d --name ${APP_NAME} -p 8080:8080 ${DOCKER_IMAGE}:latest
                """
            }
        }
 
    }
 
    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
