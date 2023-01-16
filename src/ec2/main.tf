# Get Availability Zones
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a Private Key and encode it as PEM.
resource "aws_key_pair" "key_pair" {
  key_name   = "Key_BI"
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key.private_key_pem}' > ./key.pem"
  }
}


resource "aws_iam_role" "ec2_labados_role" {
  name = "ec2_labados_role"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "ec2_labdados_policy" {
  name = "ec2_labdados_policy"
  role = aws_iam_role.ec2_labados_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_labdados_profile" {
  name = "ec2_labdados_profile"
  role = aws_iam_role.ec2_labados_role.name
}


# Create a EC2 Instance (Windows Server 2022)
resource "aws_instance" "windows" {
  instance_type          = "m5n.xlarge"
  ami                    = data.aws_ami.windows.id
  iam_instance_profile   = aws_iam_instance_profile.ec2_labdados_profile.name
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnet

  tags = {
    Name = "Labdados-BI-Windows"
  }

  root_block_device {
    volume_size = 100
  }
}

# Create and assosiate an Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.windows.id
}