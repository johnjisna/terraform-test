pipeline {
    agent any

    options { 
        buildDiscarder(logRotator(numToKeepStr: "3")) 
    }

    tools {
        terraform 'Terraform'
    }

    environment {
        AWS_REGION = "${REGION}"
        S3_BUCKET = "terraform-logs-123"
    }

    parameters {
        booleanParam(name: 'DESTROY_INFRA', defaultValue: false, description: 'Set to true if you want to destroy infrastructure')
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
                        sh 'terraform plan -out=tfplan > plan_output.txt'
                        sh 'aws s3 cp plan_output.txt s3://${S3_BUCKET}/plan_output-${BUILD_NUMBER}.txt'
                        echo "Terraform plan uploaded to: s3://${S3_BUCKET}/plan_output-${BUILD_NUMBER}.txt"
                    }
                }
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Do you want to proceed with Terraform apply/destroy?', ok: 'Proceed'
            }
        }

        stage('Terraform Apply or Destroy') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'terraform-backend-access'
                    ]]) {
                        dir('envs/dev') {
                            if (params.DESTROY_INFRA) {
                                input message: "Are you absolutely sure you want to destroy infrastructure?", ok: "Yes, Destroy!"
                                sh 'terraform destroy'
                            } else {
                                sh 'terraform apply tfplan'
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed."
        }
    }
}
