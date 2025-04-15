data "aws_ami_ids" "preferred" {
  owners = ["099720109477"]
  
  filter {
    name   = "name"
    values = [var.preferred_filter]
  }
}

data "aws_ami" "preferred" {
  count       = length(data.aws_ami_ids.preferred.ids) > 0 ? 1 : 0
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = [var.preferred_filter]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "fallback" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = [var.fallback_filter]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_instance" "web" {
  ami           = length(data.aws_ami.preferred) > 0 ? data.aws_ami.preferred[0].id : data.aws_ami.fallback.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]  # Attach the security group


user_data = <<-EOF
  #!/bin/bash
  set -ex   # Exit on error and print commands as they run

  # Log start
  echo "Starting cloud-init script execution..." | tee -a /var/log/user_data.log

  # Update package lists and install dependencies
  sudo apt-get update -y
  sudo apt-get install -y ca-certificates curl apt-transport-https software-properties-common unzip | tee -a /var/log/user_data.log

  # Add Docker's official GPG key
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Get Ubuntu codename
  UBUNTU_CODENAME=$(grep UBUNTU_CODENAME /etc/os-release | cut -d= -f2)

  # Add Docker repository
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Update package lists and install Docker
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin | tee -a /var/log/user_data.log

  # Install Docker Compose (latest version)
  DOCKER_CONFIG=$${DOCKER_CONFIG:-$HOME/.docker}
  mkdir -p $DOCKER_CONFIG/cli-plugins
  curl -SL https://github.com/docker/compose/releases/download/v2.34.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
  chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
  sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

  # Add user to docker group
  sudo usermod -aG docker ubuntu

 # Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip -d awscliv2
sudo ./awscliv2/aws/install

# Add AWS CLI to PATH for the ubuntu user
echo 'export PATH=/usr/local/bin:$PATH' >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc

# Validate AWS CLI install
/usr/local/bin/aws --version | tee -a /var/log/user_data.log

# Cleanup
rm -rf awscliv2 awscliv2.zip


  sudo reboot -i
EOF



  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
