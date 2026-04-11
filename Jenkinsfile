pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        IMAGE_NAME = "${DOCKERHUB_CREDENTIALS_USR}/project-1"
        IMAGE_TAG = "${BUILD_NUMBER}"
        TRIVY_VERSION = "0.69.3"
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '9'))
        timeout(time: 20, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

    stages {

        // Checkout -----
        stage('Checkout') {
            steps {
                checkout scm
                sh 'echo "Branch $GIT_BRANCH | Commit: $GIT_COMMIT"'
            }
        }

        // Build Docker Image ------
        stage('Build Docker Image') {
            steps {
                sh """
                    docker build \
                    --label "build-number=${BUILD_NUMBER}" \
                    -t ${IMAGE_NAME}:${IMAGE_TAG} \
                    -t ${IMAGE_NAME}:latest \
                    .
                """
            }
        }

        // trivy scan -------- fail pipeline if critical CVE is found.
        // produce report in json format as build artifact.
        stage('Trivy Security Scan') {
            steps{
                sh """
                    trivy image \
                        --exit-code 1 \
                        --severity CRITICAL \
                        --quiet \
                        --format table \
                        ${IMAGE_NAME}:${IMAGE_TAG}

                    trivy image \
                        exit code 0 \
                        --severity LOW, HIGH,CRITICAL \
                        --format json -o trivy-report.json\
                        ${IMAGE_NAME}:${IMAGE_TAG}    
                """
            }

        post {
            always{
                archiveArtifacts allowEmptyArchive: true, artifacts: 'trivy-report.json'
                // Normally, a build fails if archiving returns zero artifacts This option allows the
                // archiving process to return nothing without failing the build. Instead, the build show a warning.
                }
            }    
        }
        

        // Push to docker
        stage('Push to DockerHub') {
            steps {
                sh """
                    echo $DOCKERHUB_CREDENTIALS_PSW | \
                    docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin \
                    docker push ${IMAGE_NAME}:${IMAGE_TAG} \
                    docker push ${IMAGE_NAME}:latest
                """
            }
        }

        // Deploy
        stage('Deploy') {
            steps {
                sh """
                    docker compose down --remove-orphans || true
                    docker compose pull
                    docker compose up -d
                    docker image prune -f
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline passes. Image: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline FAILED. Check Trivy report or buiild logs"
        }
        always {
            sh 'docker logout || true'
        }
    }
}