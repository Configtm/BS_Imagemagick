pipeline {
    agent none  // We will set agent per stage

    environment {
        GITHUB_REPO = 'https://github.com/Configtm/BS_Imagemagick.git' 
        VERSION = '7.1.1-47'
        JFROG_REPO = 'http://10.65.150.52:8081/artifactory/demo/ImageMagick-binaries/ImageMagick-7.1.1-47.tar.gz'
    }

    stages {
        stage('Checkout from GitHub') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Cloning GitHub repo..."
                    git url: "${GITHUB_REPO}", branch: 'main'
                }
            }
        }

        stage('Clean Up') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Cleaning up previous build artifacts..."
                    sh 'sudo rm -rf /home/patcher/ImageMagick-$VERSION* || true'
                    sh 'sudo rm -rf /opt/zoho/ImageMagick-$VERSION || true'
                }
            }
        }

        stage('Compile ImageMagick') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Running compilation script..."
                    sh 'chmod +x Imagemagick_7.1.sh'
                    sh './Imagemagick_7.1.sh'
                }
            }
        }

        stage('Upload to JFrog') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'ARTIFACTORY_USERNAME', passwordVariable: 'ARTIFACTORY_APIKEY')]) {
                        sh """
                            curl -u "$ARTIFACTORY_USERNAME:$ARTIFACTORY_APIKEY" -X PUT -T /home/patcher/ImageMagick-${VERSION}.tar.gz "$JFROG_REPO"
                        """
                    }
                }
            }
        }

        stage('Docker compose') {
            agent { label 'Docker-agent' }
            steps {
                sh "git clone $GITHUB_REPO"
                sh "mkdir -p ./container_test"
                sh "docker-compose up --build -d"
            }
        }
    }

    post {
        always {
            echo "Pipeline completed!"
        }
        failure {
            echo "Pipeline failed! Check logs for details."
        }
    }
}
