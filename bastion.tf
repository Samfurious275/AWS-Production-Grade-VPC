resource "aws_instance" "bastion" {
  ami                    = "ami-0abcdef1234567890" # Amazon Linux 2
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "Bastion-Host"
  }
}
