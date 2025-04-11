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
                        sh 'terraform init -no-color'
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
                        sh 'terraform plan -no-color -out=tfplan > plan_output.txt'
                        script {
                            def planContent = readFile('plan_output.txt')
                            mail to: 'jisna@sayonetech.com',
                                 subject: "Terraform Plan Output - Build #${BUILD_NUMBER}",
                                 body: """Hi,

Here is the Terraform plan output for Build #${BUILD_NUMBER}:

${planContent}

Regards,
Jenkins"""
                        }
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
                                sh 'terraform destroy -auto-approve -no-color'
                            } else {
                                sh 'terraform apply -auto-approve -no-color tfplan'
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
