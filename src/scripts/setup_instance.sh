#!/usr/bin/env bash
set -euo pipefail

# update installed packages
sudo yum update -y
sudo yum upgrade -y

# install docker and enable it
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker ec2-user
