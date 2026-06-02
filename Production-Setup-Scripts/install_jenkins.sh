#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "===================================================="
echo " Automating Jenkins Installation (Java 21) for RHEL 9.6"
echo "===================================================="

# 1. Install OpenJDK 21
echo "[1/5] Installing OpenJDK 21..."
sudo dnf install -y java-21-openjdk wget

# 2. Add Jenkins Repository
echo "[2/5] Fetching Jenkins LTS Repository and Importing GPG Key..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# 3. Install Jenkins
echo "[3/5] Installing Jenkins package via DNF..."
sudo dnf install -y jenkins

# 4. Open Firewall Port 8080
echo "[4/5] Opening Firewall port 8080..."
if systemctl is-active --quiet firewalld; then
    sudo firewall-cmd --permanent --add-port=8080/tcp
    sudo firewall-cmd --reload
else
    echo "Firewalld is not active. Skipping port rules configuration."
fi

# 5. Start and Enable Jenkins
echo "[5/5] Activating and configuring Jenkins service..."
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Critical: Allow the Jenkins service user access to build Docker containers
if getent group docker > /dev/null; then
    sudo usermod -aG docker jenkins
    sudo systemctl restart jenkins
    echo "Successfully assigned 'jenkins' system user to the 'docker' group."
fi

echo "===================================================="
echo " JENKINS INSTALLATION COMPLETE!"
echo " Access dashboard via: http://$(hostname -I | awk '{print $1}'):8080"
echo " "
echo " Use the key below to unlock the administrator panel:"
echo "----------------------------------------------------"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo "----------------------------------------------------"
echo "===================================================="