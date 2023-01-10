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

# Create a EC2 Instance (Ubuntu 20)
resource "aws_instance" "windows" {
  instance_type          = "t3.micro" # free instance
  ami                    = data.aws_ami.windows.id
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnet

  tags = {
    Name = "TFteste Generated EC2"
  }

  root_block_device {
    volume_size = 100
  }
}

# Create and assosiate an Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.windows.id
}