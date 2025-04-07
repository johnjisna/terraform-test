pipeline {
    agent any

    options { 
        buildDiscarder(logRotator(numToKeepStr: "3")) 
    }

    tools {
        terraform 'Terraform'
    }

    environment {
        AWS_REGION = 'us-east-1'
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

        stage('Terraform Apply or Destroy') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'terraform-backend-access'
                    ]]) {
                        dir('envs/dev') {
                            if (params.DESTROY_INFRA) {
                                input message: "Confirm Destroy?", ok: "Yes, Destroy!"
                                sh 'terraform destroy -auto-approve'
                            } else {
                                sh 'terraform apply -auto-approve'
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline executed successfully!"
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
