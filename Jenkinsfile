pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = "dockerhub"   // Jenkins credentials ID
        DOCKER_IMAGE = "abdulahad9049/django-notes-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Ahad9049/django-notes-app.git'
            }
        }

           stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKERHUB_CREDENTIALS,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build --pull -t $DOCKER_IMAGE:$IMAGE_TAG ."
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh """
                docker push $DOCKER_IMAGE:$IMAGE_TAG
                """
            }
        }

        stage('Run Containers (Dev & Stage)') {
            steps {
                sh """
                # Stop & remove old containers if exist
                docker rm -f dev-container || true
                docker rm -f stage-container || true

                # Run DEV container (port 3001)
                docker run -d -p 8001:8000 --name dev-container $DOCKER_IMAGE:$IMAGE_TAG

                # Run STAGE container (port 3002)
                docker run -d -p 8002:8000 --name stage-container $DOCKER_IMAGE:$IMAGE_TAG
                """
            }
        }
    }

    post {
        success {
            echo "Deployment successful! Dev → port 8001 | Stage → port 8002"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
