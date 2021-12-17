data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2"
}


data "template_file" "user_data_hw" {
  template = <<EOF
#!/bin/bash -xe
yum -y install vim-enhanced mc postgresql
EOF
}

resource "aws_launch_template" "Lab-Launch-Template" {
  name                                 = join("", [var.DeploymentName, "-Launch-Template"])
  image_id                             = data.aws_ssm_parameter.ami.value
  instance_initiated_shutdown_behavior = "terminate"
  instance_market_options {
    market_type = "spot"
  }
  instance_type = "t4g.micro"
  user_data     = base64encode(data.template_file.user_data_hw.rendered)
}




resource "aws_security_group" "ssh-only-sg" {
  name        = "ssh-only-sg"
  description = "Allow http(s)"
  vpc_id      = var.VPCID

  ingress = [
    {
      description      = "ssh traffic"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


  egress = [
    {
      description      = "Default rule"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]


  tags = {
    Name = "allow_ssh"
  }
}
