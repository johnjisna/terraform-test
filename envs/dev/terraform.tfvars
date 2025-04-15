ami_id         = "ami-03e31863b8e1f70a5"
EC2_AMI_FILTER = "ubuntu/images/hvm-ssd/ubuntu-jammy-24.04-amd64-server-*"
instance_type  = "t2.micro"
key_name       = "my-key"
instance_name  = "my-ec2-instance"
region         = "us-east-1"

secret_name        = "sayonetech-dev-secret-version-1"
secret_description = "Database credentials for updated application"
secret_values = {
  username = "newadmin"
  password = "NewSuperSecret456"
}

ecr_repository_name      = "sayonetech-dev"
ecr_scan_on_push         = true
ecr_image_tag_mutability = "IMMUTABLE"
environment              = "dev"
project                  = "sayonetech"

iam_user_name_backend  = "sayonetech-backend-user"
iam_user_name_frontend = "sayonetech-frontend-user"
iam_role_name_backend  = "sayonetech-backend-role"
iam_role_name_frontend = "sayonetech-frontend-role"
iam_role_name          = "sayonetech-ecr-read-role"
trusted_services       = ["ec2.amazonaws.com"]

acm_certificate_arn = ""
custom_domain_name  = ""
policy_name         = "sayonetech-s3-iam-user-policy"
policy_type         = "private_iam"
bucket_name         = "sayonetech-dev-bucket"

sg_name        = "sayonetech-sg"
sg_description = "Security group for web servers"

ingress_rules = [
  { port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },  # SSH
  { port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },  # HTTP
  { port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }  # HTTPS
]

jenkins_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCynl2Qob9tiv8w8pu3rWmOPdZ6eR7fBIEBiBVTWJoBguNZQueBAE4qFJVGRkEUQTDJh+nGZ0tVTczk0ZpUPW7/P8foXQTAZThNCNBoSwjsOwHSoGhTL2uMd6eBHNOrzmNmDoCRp3MlCF8Q818/zzYJFUURyLpNRhOlbmfvJtVQVA7ltcqPU3IOeXqBHCSfjnCEfsKTzDKKrenG+8/FvluceQbIuYrwzA6iKhG8yrtskKfHeZbkwwuMhPQ4CtPTBTqkeq30qKUzAosvBLf2aZYtjcp6HGgFu1R5c/7cD8SFwkO418viRQZoMTCfQiMDoHBex4Y6mbA1LT8DOWcwGSLEq1F8OV5Pq6uSbewRuj1nRc6S/VsVOiCkKxhJxHdazw8BJE+72qogs7HlhQWhho9vQg80BZ1xTzaMettpqFyqskk259flNzGAkon72UbUAcAjLRwRgWKc/WTSxsHjCAy1J2tKfjiLxYpaGpoK67o30sq2943mFDGh+Bz7N7X6WMA7vTOxdYNhJur9Aj5OVDz91LD9doI9YLT1+F8PQbcNgJYWo8BN2zOCS/teP4Y+F8qIzJir9EVwJwNAjPMhYEJjh3SGW6GKY79NfNYpWiRMinyBkXx6sh/fMmTphtJb9N7y6Z5R+s3MJuiD32faAhA5DQg6rI+XZNmV/giuGNltJQ== jenkins-server"

