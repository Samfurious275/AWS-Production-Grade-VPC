resource "aws_instance" "bastion" {
  ami                    = "ami-0e95a5e2743ec9ec9" # Amazon Linux 2
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "Bastion-Host"
  }
}
