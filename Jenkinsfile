pipeline {
    agent none

    environment {
        GITHUB_REPO = 'https://github.com/Configtm/BS_Imagemagick.git' 
        VERSION = '7.1.1-47'
        JFROG_REPO = 'http://10.65.150.52:8081/artifactory/demo/ImageMagick-binaries/ImageMagick-7.1.1-47.tar.gz'
        PROXY = 'http://192.168.100.100:3128'
    }

    stages {
        stage('Checkout from GitHub') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Cloning GitHub repo..."
                    withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        withEnv(["GH_USER=$GIT_USER", "GH_PASS=$GIT_PASS"]) {
                            sh '''
                                git config --global credential.helper store
                                echo "https://$GH_USER:$GH_PASS@github.com" > ~/.git-credentials

                                git config --global http.proxy "$PROXY"
                                git config --global https.proxy "$PROXY"

                                git clone https://github.com/Configtm/BS_Imagemagick.git
                            '''
                        }
                    }
                }
            }
        }

        stage('Clean Up') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Cleaning up previous build artifacts..."
                    sh "sudo rm -rf /home/patcher/ImageMagick-${VERSION}* || true"
                    sh "sudo rm -rf /opt/zoho/ImageMagick-${VERSION} || true"
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
                        withEnv(["JF_USER=$JFROG_USER", "JF_KEY=$JFROG_APIKEY"]) {
                            sh '''
                                curl -u "$JF_USER:$JF_KEY" -X PUT -T /home/patcher/ImageMagick-7.1.1-47.tar.gz "http://10.65.150.52:8081/artifactory/demo/ImageMagick-binaries/ImageMagick-7.1.1-47.tar.gz"
                            '''
                        }
                    }
                }
            }
        }

        stage('Docker compose') {
            agent { label 'Docker-agent' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'JFROG_USER', passwordVariable: 'JFROG_APIKEY')]) {
                        withEnv(["JF_USER=$JFROG_USER", "JF_KEY=$JFROG_APIKEY"]) {
                            sh '''
                                rm -rf BS_Imagemagick container_test
                                git clone https://github.com/Configtm/BS_Imagemagick.git
                                mkdir -p ./container_test

                                echo "JFROG_USER=$JF_USER" > .env
                                echo "JFROG_APIKEY=$JF_KEY" >> .env

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
