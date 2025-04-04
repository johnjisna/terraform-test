pipeline {
    agent any

    tools {
        terraform 'Terraform' 
    }

    stages {
        stage('Terraform Init') {
            steps {
                script {
                    dir('env/dev') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    dir('env/dev') {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    dir('env/dev') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }
}
