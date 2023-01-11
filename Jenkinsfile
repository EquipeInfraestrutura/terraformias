pipeline {
    agent any

    stages {

        stage('Checkout source') {
            steps {
                git url: 'https://github.com/EquipeInfraestrutura/terraformias.git', branch: 'main'
            }
        }

        stage('Criação ou atualização da infra') {
            environment {
                bucket = credentials('bucket')
                key = credentials('key')
                region = credentials('region')
                access_key = credentials('access_key')
                secret_key = credentials('secret_key')

            }
            steps {
                
                script {
                    dir('src') {
                        sh 'terraform init -migrate-state --backend-config "bucket=${bucket}" --backend-config "key=${key}" --backend-config "access_key=${region}" --backend-config "access_key=${access_key}" --backend-config "secret_key=${secret_key}"'
                        sh 'terraform plan'
                    }
                }
            }
        }

    }

}