#!/bin/bash

# Update system..
echo "Installing updates.."

sudo apt update && sudo apt upgrade -y

echo " System updated"

# Install Terraform..

wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

echo "Installing Terraform.."

sudo apt update
sudo apt install terraform -y

echo " Terraform successfully installed"

echo "Terraform Version installed"

terraform -v

# Install AWS CL1V2..

echo "Installing AWS CLIV2.."

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

sudo apt install unzip -y
unzip awscliv2.zip

sudo ./aws/install

echo " AWS CLIV2 successfully installed"

echo "AWS CL1V2 version installed"

aws --version
