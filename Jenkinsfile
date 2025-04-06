pipeline {
    agent none

    environment {
        GITHUB_REPO = 'https://github.com/Configtm/BS_Imagemagick.git' 
        VERSION = '7.1.1-47'
        JFROG_REPO = 'http://10.65.150.52:8081/artifactory/demo/ImageMagick-binaries/ImageMagick-7.1.1-47.tar.gz'
        PROXY = 'http://192.168.100.100:3128'
    }

    stages {

        stage('Clean Up') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Cleaning up previous build artifacts..."
                    sh """
                        sudo rm -rf /home/patcher/ImageMagick-${VERSION}* || true
                        sudo rm -rf /opt/zoho/ImageMagick-${VERSION} || true
                        rm -rf BS_Imagemagick || true
                    """
                }
            }
        }

        stage('Checkout from GitHub') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Cloning GitHub repo..."
                    withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        withEnv(["GIT_USER=${GIT_USER}", "GIT_PASS=${GIT_PASS}"]) {
                            sh '''
                                git config --global credential.helper store
                                echo "https://${GIT_USER}:${GIT_PASS}@github.com" > ~/.git-credentials

                                git config --global http.proxy "$PROXY"
                                git config --global https.proxy "$PROXY"

                                git clone $GITHUB_REPO
                            '''
                        }
                    }
                }
            }
        }

        stage('Compile ImageMagick') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Running compilation script..."
                    sh "chmod +x Imagemagick_7.1.sh"
                    sh "./Imagemagick_7.1.sh"
                }
            }
        }

        stage('Upload to JFrog') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'JFROG_USER', passwordVariable: 'JFROG_APIKEY')]) {
                        sh """
                            curl -u "${JFROG_USER}:${JFROG_APIKEY}" -X PUT -T /home/patcher/ImageMagick-${VERSION}.tar.gz "${JFROG_REPO}"
                        """
                    }
                }
            }
        }

        stage('Docker compose') {
            agent { label 'Docker-agent' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'JFROG_USER', passwordVariable: 'JFROG_APIKEY')]) {
                        withEnv(["JFROG_USER=${JFROG_USER}", "JFROG_APIKEY=${JFROG_APIKEY}"]) {
                            sh '''
                                rm -rf BS_Imagemagick container_test
                                git clone $GITHUB_REPO
                                mkdir -p ./container_test

                                echo "JFROG_USER=$JFROG_USER" > .env
                                echo "JFROG_APIKEY=$JFROG_APIKEY" >> .env

                                docker-compose up --build
                                docker rm imagemagick_test
                            '''
                        }
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
