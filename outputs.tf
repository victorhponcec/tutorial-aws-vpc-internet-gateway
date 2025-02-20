#Retrieve AWS AZ Information
data "aws_region" "current" {}

output "current_region" {
  value = data.aws_region.current.name
}

output "instance_ip" {
  value = aws_instance.amazon_linux.public_ip
}