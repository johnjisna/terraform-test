pipeline {
    agent any

tools {
    terraform 'Terraform' 
}

    environment {
        AWS_REGION = "us-east-1"
        S3_BUCKET = "backenddb-terraform"
        DYNAMODB_TABLE = "backend-db"
    }

    stages {
        
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    input message: "Approve Terraform Apply?"
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

    }

    post {
        success {
            slackSend(color: '#00FF00', message: "Terraform applied successfully ✅")
        }
        failure {
            slackSend(color: '#FF0000', message: "Terraform failed ❌")
        }
    }
}
