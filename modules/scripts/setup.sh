
#!/bin/bash

set -e  

sudo apt update -y
sudo apt install -y unzip curl

if ! command -v aws &> /dev/null; then
    echo "Installing AWS CLI..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf awscliv2.zip aws
else
    echo "AWS CLI is already installed."
fi

if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed."
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed."
fi

echo "Adding Jenkins public key..."
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCynl2Qob9tiv8w8pu3rWmOPdZ6eR7fBIEBiBVTWJoBguNZQueBAE4qFJVGRkEUQTDJh+nGZ0tVTczk0ZpUPW7/P8foXQTAZThNCNBoSwjsOwHSoGhTL2uMd6eBHNOrzmNmDoCRp3MlCF8Q818/zzYJFUURyLpNRhOlbmfvJtVQVA7ltcqPU3IOeXqBHCSfjnCEfsKTzDKKrenG+8/FvluceQbIuYrwzA6iKhG8yrtskKfHeZbkwwuMhPQ4CtPTBTqkeq30qKUzAosvBLf2aZYtjcp6HGgFu1R5c/7cD8SFwkO418viRQZoMTCfQiMDoHBex4Y6mbA1LT8DOWcwGSLEq1F8OV5Pq6uSbewRuj1nRc6S/VsVOiCkKxhJxHdazw8BJE+72qogs7HlhQWhho9vQg80BZ1xTzaMettpqFyqskk259flNzGAkon72UbUAcAjLRwRgWKc/WTSxsHjCAy1J2tKfjiLxYpaGpoK67o30sq2943mFDGh+Bz7N7X6WMA7vTOxdYNhJur9Aj5OVDz91LD9doI9YLT1+F8PQbcNgJYWo8BN2zOCS/teP4Y+F8qIzJir9EVwJwNAjPMhYEJjh3SGW6GKY79NfNYpWiRMinyBkXx6sh/fMmTphtJb9N7y6Z5R+s3MJuiD32faAhA5DQg6rI+XZNmV/giuGNltJQ== jenkins-server" >> /home/ubuntu/.ssh/authorized_keys


echo "Installation completed successfully!"
echo "Rebooting the system in 10 seconds to apply changes..."
sleep 10
sudo reboot
