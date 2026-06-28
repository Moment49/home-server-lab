#! /bin/bash

echo "🚀 Setting up home server environment..."

echo "Making the necessary update to the system..."

echo "Installing the necessary packages..."

# Update the system
sudo apt update && sudo apt upgrade -y

# Install the neccessary packages
sudo apt install -y \
    git-all \
    curl \
    wget \
    vim \
    htop \
    build-essential \
    ufw \
    fail2ban \

# Install Tailscale for remote access
curl -fsSL https://tailscale.com/install.sh | sh


# Set up the Docker apt repository
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

# Install Docker package
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Check docker version and status of docker service
sudo docker --version
sudo systemctl status docker
sudo systemctl start docker


# Configure fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

echo "✅ Base setup complete!"



