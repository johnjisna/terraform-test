pipeline {
    agent any

    tools {
        terraform 'Terraform'
    }

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Verify AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'terraform-backend-access'
                ]]) {
                    sh 'aws sts get-caller-identity'
                }
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
