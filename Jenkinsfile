pipeline {
    agent any

    tools {
        terraform 'Terraform'
    }

    environment {
        AWS_REGION = 'us-east-1' // Update to your region if different
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'terraform-backend-access'
                ]]) {
                    dir('envs/dev') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'terraform-backend-access'
                ]]) {
                    dir('envs/dev') {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'terraform-backend-access'
                ]]) {
                    dir('envs/dev') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }
}
