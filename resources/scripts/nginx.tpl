sudo apt-get update
sudo apt install -y nginx &&
sudo systemctl start nginx.service
sudo systemctl enable nginx.service
