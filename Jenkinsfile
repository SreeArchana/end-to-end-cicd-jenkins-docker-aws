
pipeline {
    agent any

    environment {
        IMAGE_NAME = 'flask-cicd-app'
        CONTAINER_NAME = 'flask-cicd-container'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv .venv
                    . .venv/bin/activate
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    . .venv/bin/activate
                    python3 -m pytest -v
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $IMAGE_NAME:$BUILD_NUMBER .
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f $CONTAINER_NAME || true

                    docker run -d \
                      --name $CONTAINER_NAME \
                      --restart unless-stopped \
                      -p 5001:5000 \
                      $IMAGE_NAME:$BUILD_NUMBER
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    for i in $(seq 1 10); do
                        if curl -fsS http://localhost:5001/health; then
                            echo "Application is healthy!"
                            exit 0
                        fi
                        sleep 3
                    done

                    docker logs $CONTAINER_NAME
                    exit 1
                '''
            }
        }
    }

    post {
        always {
            sh 'rm -rf .venv'
        }
    }
}
