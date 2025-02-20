#Configuring AWS Provider
provider "aws" {
  region = "us-east-1"
}

#VPC 
resource "aws_vpc" "main" {
  cidr_block = "10.111.0.0/16"
}

#Subnet Public
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.111.1.0/24"
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

#Route Tables
#Public Route table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Create route table associations
#Associate public Subnet to public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}

#SSH Config
#Create PEM File
resource "tls_private_key" "pkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.pkey.private_key_pem
  filename = "AWSKeySSH.pem"
  file_permission = "0400"
}

#AWS SSH EC2 Key Pair | uses tls_private_key to generate public key
resource "aws_key_pair" "ec2_key" {
  key_name   = "AWSKeySSH"
  public_key = tls_private_key.pkey.public_key_openssh
  
  lifecycle {
    ignore_changes = [key_name] #to ensure it creates a different pair of keys each time
  }
}
