pipeline {
    agent any
    environment {
        JFROG_SERVER_ID = 'jfrog-artifactory'                     // Matches Server ID in system settings
        JFROG_REPO = 'imagemagick-binaries'                       // Your Artifactory repo
        JFROG_URL = 'http://10.65.150.52:8082/artifactory'        // Artifactory base URL
        OUTPUT_TAR = '/tmp/ImageMagick-7.1.1-45.tar.gz'           // Matches your script’s output
        GITHUB_REPO = 'https://github.com/Configtm/BS_Imagemagick.git' // Your GitHub repo
    }
    stages {
        stage('Checkout from GitHub') {
            steps {
                script {
                    echo "Cloning GitHub repo..."
                    git url: "${GITHUB_REPO}", branch: 'main'
                }
            }
        }
        stage('Clean Up') {
            steps {
                script {
                    echo "Cleaning up previous build artifacts..."
                    sh 'sudo rm -rf /tmp/ImageMagick-7.1.1-45* || true'
                    sh 'sudo rm -rf /opt/zoho/ImageMagick-7.1.1-45 || true'
                }
            }
        }
        stage('Compile ImageMagick') {
            steps {
                script {
                    echo "Running compilation script..."
                    sh 'chmod +x Imagemagick_7.1.sh'
                    sh './Imagemagick_7.1.sh'
                }
            }
        }
        stage('Upload to JFrog') {
            steps {
                script {
                    echo "Uploading binary tar to JFrog Artifactory..."
                    withCredentials([usernamePassword(credentialsId: 'jfrog-token', usernameVariable: 'JFROG_USER', passwordVariable: 'JFROG_TOKEN')]) {
                        sh """
                            jf config add ${JFROG_SERVER_ID} --url=${JFROG_URL} --user=${JFROG_USER} --password=${JFROG_TOKEN} --interactive=false --enc-password=false --basic-auth-only=true
                            jf rt upload ${OUTPUT_TAR} ${JFROG_REPO}/ImageMagick-7.1.1-45.tar.gz
                        """
                    }
                }
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
