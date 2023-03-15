/*==== EC2 ======*/
resource "aws_instance" "server" {
  instance_type          = "t2.micro"
  ami                    = "ami-06d94a781b544c133"
  user_data              = file("./resources/scripts/nginx.tpl")
  vpc_security_group_ids = [module.networking.sg_id]
  subnet_id = module.networking.public_subnet_id
  key_name = aws_key_pair.nginx_server_key.key_name
}

/*==== EC2 Key Pair ======*/
resource "aws_key_pair" "nginx_server_key" {
  key_name = "nginx-server-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "private_key" {
  content = tls_private_key.key.private_key_pem
  filename = "./resources/secrets/private_key"
}

/*==== EC2 Config Bucket ======*/
resource "aws_s3_bucket" "S3_config" {
  bucket = "trjw-config-bucket"
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.S3_config.id
  acl    = "private"
}

resource "aws_s3_object" "BootlegFile" {
  bucket = aws_s3_bucket.S3_config.id
  key = "test"
  content = file("./resources/blob/test.txt")
}

output "public_dns" {
  value = aws_instance.server.public_dns
}
