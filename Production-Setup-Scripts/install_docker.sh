#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "===================================================="
echo " Automating Docker CE Installation for RHEL 9.6"
echo "===================================================="

# 1. Install prerequisites
echo "[1/4] Installing yum-utils..."
sudo dnf install -y yum-utils

# 2. Add Official Docker Repo
echo "[2/4] Adding Docker CE repository..."
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 3. Install Docker Engine (with --allowerasing to clean out podman/buildah conflicts)
echo "[3/4] Installing Docker Engine & CLI Components..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io --allowerasing

# 4. Configure Service & User Permissions
echo "[4/4] Starting Docker daemon and managing permissions..."
sudo systemctl enable docker
sudo systemctl start docker

# Ensure docker group exists
sudo groupadd -f docker

# Add current user to docker group
sudo usermod -aG docker $USER

echo "===================================================="
echo " DOCKER INSTALLATION COMPLETE!"
echo " IMPORTANT: Please log out and log back in (or run 'newgrp docker')"
echo " to apply the group membership changes to your user context."
echo "===================================================="