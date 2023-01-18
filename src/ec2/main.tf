# Create a EC2 Instance (Windows Server 2022)
resource "aws_instance" "windows" {
  instance_type          = "m5n.xlarge"
  ami                    = data.aws_ami.windows.id
  key_name               = "Key_Labdados"
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnet

  tags = {
    Name = "Labdados-BI-Windows"
  }

  root_block_device {
    volume_size = 120
  }
}

# Create and assosiate an Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.windows.id
}