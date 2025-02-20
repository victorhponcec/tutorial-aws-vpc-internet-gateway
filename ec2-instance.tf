#EC2 Instances
resource "aws_instance" "amazon_linux" {
  ami                         = "ami-05576a079321f21f8"
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.web.id, aws_security_group.ssh.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ec2_key.key_name
}