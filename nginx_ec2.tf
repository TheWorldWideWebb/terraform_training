
resource "aws_default_vpc" "nginx_vpc" {

}

resource "aws_security_group" "nginx_sg" {
  name        = "nginx_sg"
  description = "allow ssh on 22 & icmp (ping) on 433"
  vpc_id      = aws_default_vpc.nginx_vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 433
    to_port = 433
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx_server" {
  instance_type          = "t2.micro"
  ami                    = "ami-06d94a781b544c133"
  user_data              = file("./resources/scripts/nginx.tpl")
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name = aws_key_pair.nginx_server_key.key_name
}


resource "aws_key_pair" "nginx_server_key" {
  key_name = "nginx_server_key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "private_key" {
  content = tls_private_key.key.private_key_pem
  filename = "private_key"
  file_permission = "800"
  directory_permission = "700"
}

output "aws_instance_public_dns" {
  value = aws_instance.nginx_server.public_dns
}
