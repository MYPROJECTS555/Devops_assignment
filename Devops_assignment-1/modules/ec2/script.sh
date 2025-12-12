#!/bin/bash

# Install Git, Docker, Docker Compose on Ubuntu/Debian
# Run as root: sudo chmod +x install.sh && sudo ./install.sh

set -e  # Exit on any error

echo "🚀 Starting installation..."

# Update package list
apt-get update -y

# Install Git
apt-get install -y git
git --version

# Install Docker
apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose (v2 - plugin)
apt-get install -y docker-compose-plugin
docker compose version

# Add current user to docker group (logout/login required)
usermod -aG docker $SUDO_USER || true

# Start Docker services
systemctl start docker
systemctl enable docker

echo "✅ Installation complete!"
echo "🔄 Logout and login again for Docker group changes"
echo "🧪 Test: docker run hello-world"
