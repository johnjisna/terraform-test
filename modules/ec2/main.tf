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

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.iam_role_name != "" ? 1 : 0
  name  = "${var.iam_role_name}-instance-profile"
  role  = var.iam_role_name
}

resource "aws_instance" "web" {
  ami           = length(data.aws_ami.preferred) > 0 ? data.aws_ami.preferred[0].id : data.aws_ami.fallback.id
  instance_type = var.instance_type
  key_name      = var.key_name

#iam_instance_profile = var.iam_role_name != "" ? aws_iam_instance_profile.ec2_profile[0].name : null
 iam_instance_profile = var.iam_instance_profile_name


  vpc_security_group_ids = [var.security_group_id]
  user_data              = file("${path.module}/${var.EC2_USER_DATA}")

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}


