#!/bin/bash

# Ensure the .ssh directory exists and set up authorized keys
mkdir -p /home/ec2-user/.ssh
{
    echo -e "${admin_key}"
    echo -e "${server_key}"
} >> /home/ec2-user/.ssh/authorized_keys
chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
chmod 600 /home/ec2-user/.ssh/authorized_keys

# Create a GPT partition table on /dev/nvme1n1
sudo parted /dev/nvme1n1 mklabel gpt

# Create a primary ext4 partition using the entire disk
sudo parted /dev/nvme1n1 mkpart primary ext4 0% 100%

# Format the new partition with ext4
sudo mkfs.ext4 /dev/nvme1n1p1

# Mount the new partition temporarily to copy data
sudo mount /dev/nvme1n1p1 /mnt/temp

sudo mkdir -p /server

sudo rsync -av /server/ /mnt/temp

# Unmount the temporary mount point
sudo umount /mnt/temp

# Mount the new partition at /server
sudo mount /dev/nvme1n1p1 /server

# Update /etc/fstab for automatic mounting at boot
echo "/dev/nvme1n1p1 /server ext4 defaults 0 0" | sudo tee -a /etc/fstab

# Change ownership of the mounted directory (if necessary)
# Replace 'ec2-user:ec2-user' with the appropriate user and group names
sudo chown -R ec2-user:ec2-user /server

# Create the required directory hierarchy under /server/
#sudo mkdir -p /server
sudo mkdir -p /server/source
sudo mkdir -p /server/data/grafana
sudo mkdir -p /server/data/influxdb
sudo mkdir -p /server/backup/influxdb
sudo mkdir -p /server/cert/grafana
sudo mkdir -p /server/cert/nginx
sudo mkdir -p /server/logs/signal-suite
sudo mkdir -p /server/logs/data-sync
sudo mkdir -p /server/conf

sudo chmod u+x /server/data/grafana/
sudo chmod -R 777 /server/data/grafana/

# Write Nginx certificate and key
echo -e "${nginx_cert_key}" > /server/cert/nginx/cert.pem
echo -e "${nginx_key}" > /server/cert/nginx/key.pem
sudo chown root:root /server/cert/nginx/cert.pem
sudo chown root:root /server/cert/nginx/key.pem
sudo chmod 600 /server/cert/nginx/cert.pem
sudo chmod 600 /server/cert/nginx/key.pem

# Install Git, update the system, and install Docker
sudo yum install -y git
sudo yum update -y
sudo yum install -y docker

# Start Docker service and add ec2-user to the Docker group
sudo service docker start
sudo usermod -a -G docker ec2-user

# stop docker
sudo systemctl stop docker

# create a place for docker to keep its shit
sudo mkdir /server/docker

echo '{"data-root": "/server/docker"}' | sudo tee /etc/docker/daemon.json

# start docker
sudo systemctl start docker

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo pip3 install PyYaml

cd /server/source || exit
sudo git clone https://"${github_token}"@github.com/repo/software.git
cd signal-plotter || exit
sudo git checkout development
sudo cp ./nginx* /server/conf/

sudo chmod u+x app.init.sh
sudo sh /server/source/software/app.init.sh dev

