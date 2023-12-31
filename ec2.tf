resource "aws_instance" "bastion" {
  ami                  = "ami-0cfc97bf81f2eadc4"
  instance_type        = "t2.micro"
  subnet_id            = module.vpc.public_subnets[0]
  security_groups      = [aws_security_group.ec2_bastion.id]
  iam_instance_profile = aws_iam_instance_profile.bastion.name

  associate_public_ip_address = true

  tags = {
    Name = "${local.name_prefix}-bastion"
  }

  user_data = <<EOF
#! /bin/bash

sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
	EOF

  lifecycle {
    ignore_changes = [security_groups]
  }
}

resource "aws_instance" "micro_service1" {
  ami                  = "ami-0cfc97bf81f2eadc4"
  instance_type        = "t2.micro"
  subnet_id            = module.vpc.private_subnets[0]
  security_groups      = [aws_security_group.ec2_micro_service.id]
  iam_instance_profile = aws_iam_instance_profile.micro_service.name

  tags = {
    Name = "${local.name_prefix}-micro1"
  }

  lifecycle {
    ignore_changes = [security_groups]
  }
}

resource "aws_instance" "micro_service2" {
  ami                  = "ami-0cfc97bf81f2eadc4"
  instance_type        = "t2.micro"
  subnet_id            = module.vpc.private_subnets[0]
  security_groups      = [aws_security_group.ec2_micro_service.id]
  iam_instance_profile = aws_iam_instance_profile.micro_service.name

  tags = {
    Name = "${local.name_prefix}-micro2"
  }

  lifecycle {
    ignore_changes = [security_groups]
  }
}

resource "aws_instance" "micro_service3" {
  ami                  = "ami-0cfc97bf81f2eadc4"
  instance_type        = "t2.micro"
  subnet_id            = module.vpc.private_subnets[0]
  security_groups      = [aws_security_group.ec2_micro_service.id]
  iam_instance_profile = aws_iam_instance_profile.micro_service.name

  tags = {
    Name = "${local.name_prefix}-micro3"
  }

  lifecycle {
    ignore_changes = [security_groups]
  }
}

output "ec2_bastion_instance_id" {
  value = aws_instance.bastion.id
}