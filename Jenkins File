pipeline {
    agent any

    // Optional: Ensure Maven is available from Jenkins global tools
    tools {
        // Replace 'M3' with your Maven installation name in Jenkins Global Tool Configuration
        maven 'M3'
    }

    options {
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '20'))
        ansiColor('xterm')
        timeout(time: 30, unit: 'MINUTES')
    }

    parameters {
        string(name: 'GIT_BRANCH', defaultValue: 'main', description: 'Git branch to build')
    }

    environment {
        APP_NAME      = 'myapp'
        DOCKER_IMAGE  = 'myapp-image'
        IMAGE_TAG     = "${env.BUILD_NUMBER}"
        // Optional: for private registries
        // DOCKER_REGISTRY = 'registry.example.com'
        // DOCKER_CREDENTIALS_ID = 'docker-hub-creds'
    }

    stages {

        stage('Git Clone') {
            steps {
                // If your repo is public, this is fine.
                // For private repos, add 'credentialsId: "your-credential-id"'
                // and ensure Jenkins has the credential configured.
                git branch: params.GIT_BRANCH, url: 'https://github.com/your-repo/your-project.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh '''
                    set -euxo pipefail
                    mvn --version
                    mvn clean package -DskipTests
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                    set -euxo pipefail
                    DOCKER_BUILDKIT=1 docker build \
                      --pull \
                      -t ${DOCKER_IMAGE}:latest \
                      -t ${DOCKER_IMAGE}:${IMAGE_TAG} \
                      .
                '''
            }
        }

        stage('Docker Run') {
            steps {
                sh '''
                    set -euxo pipefail
                    # Stop and remove existing container if present
                    docker rm -f ${APP_NAME} || true

                    # Run the new container
                    docker run -d --name ${APP_NAME} \
                        --restart unless-stopped \
                        -p 8080:8080 \
                        ${DOCKER_IMAGE}:${IMAGE_TAG}
                '''
            }
        }

        // Optional: Smoke Test
        stage('Health Check') {
            steps {
                // If the app exposes a health endpoint, uncomment/adjust the curl:
                sh '''
                    set -euxo pipefail
                    sleep 5
                    # Basic check; replace with actual health endpoint
                    # curl -f http://localhost:8080/actuator/health || (docker logs ${APP_NAME} && exit 1)
                    docker ps --filter "name=${APP_NAME}"
                    docker logs --tail=100 ${APP_NAME} || true
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully! Image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline failed!"
            // Show recent logs to aid debugging
            sh 'docker logs --tail=200 ${APP_NAME} || true'
        }
        always {
            // Optional: archive build artifacts (uncomment if needed)
            // archiveArtifacts artifacts: 'target/*.jar', fingerprint: true, onlyIfSuccessful: true
            cleanWs()
        }
    }
}
