pipeline {
    agent any

    environment {
        CHAT_TOKEN = credentials('google-chat-guisousa')
    }

    stages {
        stage('Atualizando Código') {
            steps {
                git branch: 'master', url: 'https://github.com/gui-sousa/nginx-guizin.git'
            }

            post {
                always {
                   hangoutsNotify message: "⚙️ Iniciando build\n⏰ Horario de início: $BUILD_TIMESTAMP", token: "$CHAT_TOKEN", threadByJob: false
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    dockerapp = docker.build("4beework/dotnet-core:${env.BUILD_ID}", "-f Dockerfile .")
                }
            }
        }

        stage('Docker Push Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-4beework') {
                        dockerapp.push('latest')
                        dockerapp.push(env.BUILD_ID)
                    }
                }
            }
        }
    }

    post {
        success {
            hangoutsNotify message: "✅ Deu Certo!\n⏰ Tempo de Duração: ${currentBuild.duration / 1000} segundos", token: "$CHAT_TOKEN", threadByJob: false
        }

        failure {
           hangoutsNotify message: "❌ Deu Errado!\n⏰ Tempo de Duração: ${currentBuild.duration / 1000} segundos", token: "$CHAT_TOKEN", threadByJob: false 
        }
    }
}
