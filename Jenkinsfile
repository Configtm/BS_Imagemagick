pipeline {
    agent none

    environment {
        GITHUB_REPO = 'https://github.com/Configtm/BS_Imagemagick.git'
    }

    parameters {
        string(name: 'VERSION', defaultValue: '7.1.1-47', description: 'Enter ImageMagick version')
        string(name: 'JFROG_REPO', defaultValue: 'http://10.65.150.52:8081/artifactory/demo/ImageMagick-binaries/ImageMagick-7.1.1-47.tar.gz', description: 'JFrog upload path')
    }

    stages {
        stage('Clean Up') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Cleaning up previous build artifacts..."
                    sh '''
                        whoami
                        sudo rm -rf /home/patcher/ImageMagick-${VERSION}* 
                        sudo rm -rf /opt/zoho/ImageMagick-${VERSION} 
                    '''
                }
            }
        }

        stage('Checkout from GitHub') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Cloning GitHub repo securely..."
                    withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh '''
                            git config --global credential.helper store
                            echo "https://${GIT_USER}:${GIT_PASS}@github.com" > ~/.git-credentials

                            git config --global http.proxy http://192.168.100.100:3128
                            git config --global https.proxy http://192.168.100.100:3128

                            rm -rf BS_Imagemagick 
                            git clone https://github.com/Configtm/BS_Imagemagick.git
                        '''
                    }
                }
            }
        }

        stage('Compile ImageMagick') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    echo "Running compilation script..."
                    sh '''
                        chmod +x BS_Imagemagick/Imagemagick_7.1.sh
                        ./BS_Imagemagick/Imagemagick_7.1.sh
                    '''
                }
            }
        }

        stage('Upload to JFrog') {
            agent { label 'Build-In_Node' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'JFROG_USER', passwordVariable: 'JFROG_APIKEY')]) {
                        sh '''
                            curl -u "$JFROG_USER:$JFROG_APIKEY" -X PUT -T /home/patcher/ImageMagick-${VERSION}.tar.gz "$JFROG_REPO"
                        '''
                    }
                }
            }
        }

        stage('Docker compose') {
            agent { label 'Docker-agent' }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jfrog', usernameVariable: 'JFROG_USER', passwordVariable: 'JFROG_APIKEY')]) {
                        sh '''
                            rm -rf BS_Imagemagick container_opt 
                            git clone https://github.com/Configtm/BS_Imagemagick.git
                            mkdir -p ./container_opt
                            
                            echo "JFROG_USER=${JFROG_USER}" > .env
                            echo "JFROG_APIKEY=${JFROG_APIKEY}" >> .env

                            docker-compose up --build
                            docker rm imagemagick_test 
                        '''
                    }
                }
            }
        }

        stage('Archive Packaging Test Report') {
            agent { label 'Docker-agent' }
            steps {
                script {
                    echo "Archiving ImageMagick test report..."
                    archiveArtifacts artifacts: 'test_report.txt', allowEmptyArchive: true
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
