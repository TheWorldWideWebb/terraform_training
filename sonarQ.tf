/*==== EC2 ======*/
resource "aws_instance" "sonar_server" {
  instance_type          = "t2.micro"
  ami                    = "ami-06d94a781b544c133"
  user_data              = file("./resources/scripts/sonarQ.tpl")
  vpc_security_group_ids = [module.networking.sg_id]
  subnet_id = module.networking.private_subnet_id
  key_name = aws_key_pair.sonar_server_key.key_name
}

/*==== EC2 Key Pair ======*/
resource "aws_key_pair" "sonar_server_key" {
  key_name = "sonar-server-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "tls_private_key" "sonar_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "sonar_private_key" {
  content = tls_private_key.sonar_key.private_key_pem
  filename = "./resources/secrets/sonar_private_key"
}

output "sonar_public_dns" {
  value = aws_instance.sonar_server.public_dns
}


