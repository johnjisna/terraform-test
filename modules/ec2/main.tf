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


   user_data = file(var.EC2_USER_DATA)


  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
