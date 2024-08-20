resource "aws_instance" "example" {
  ami           = "ami-07c8c1b18ca66bb07"  # Change to your preferred AMI ID
  instance_type = "t2.micro"               # Instance type

  tags = {
    Name = "example-instance"
  }

  # Ensure you have an existing VPC and subnet
  subnet_id                   = "subnet-0134f5449c7d97a39"  # Replace with your subnet ID
  associate_public_ip_address = true               # To associate a public IP address

  # Optional - Add security group to allow SSH and HTTP access
  security_groups = ["example-security-group"]
}

resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = "vpc-01833dda82803ed0b"  # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*------------Generate SSH Key--------------*/
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
 }
/*----------Create PEM Key----------------------*/
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
 }
/*----------Download PEM Key-------------------*/
resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
 }