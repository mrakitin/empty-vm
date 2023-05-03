#!/bin/bash

# For reference: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html.
set -vxeuo pipefail

# Clean-up a leftover file (owned by root) produced before us.
sudo rm -f /home/vagrant/.wget-hsts

# Install X11 for matplotlib, etc.
sudo apt-get update
sudo apt-get install -y xserver-xorg-core x11-utils x11-apps

# Install HTTP servers/clients
sudo apt-get install -y apache2 nginx
sudo apt-get install -y httpie

# Install utilities
sudo apt-get install -y feh

# Install docker per https://docs.docker.com/engine/install/ubuntu/
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add the vagrant account to the docker group; this way the vagrant account
# can run docker without sudo
sudo usermod -aG docker vagrant

# Test docker under root
sudo docker run hello-world
