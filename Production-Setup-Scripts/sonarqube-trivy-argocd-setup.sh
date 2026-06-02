#!/bin/bash

# ==============================================================================
# SCRIPT NAME: install-devops-tools.sh
# DESCRIPTION: Standard installation of Trivy, SonarQube, and ArgoCD
# TARGET OS: RHEL / CentOS / Rocky Linux
# RUN AS: root
# ==============================================================================

set -e # Exit immediately if a command fails

# Text Formatting Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}====================================================${NC}"
echo -e "${CYAN}      STARTING GENERAL DEVOPS TOOLS INSTALLATION     ${NC}"
echo -e "${CYAN}====================================================${NC}"

# ------------------------------------------------------------------------------
# STEP 1: FIREWALL CONFIGURATION
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[STEP 1/4] Opening System Firewall Ports...${NC}"
sudo firewall-cmd --permanent --add-port=8081/tcp   # ArgoCD UI Port
sudo firewall-cmd --permanent --add-port=9000/tcp   # SonarQube UI Port
sudo firewall-cmd --reload
echo -e "${GREEN}✔ Ports 8081 and 9000 opened successfully.${NC}"


# ------------------------------------------------------------------------------
# STEP 2: INSTALL TRIVY
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[STEP 2/4] Installing Aqua Security Trivy...${NC}"
cat <<EOF | sudo tee /etc/yum.repos.d/trivy.repo
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
EOF

sudo dnf makecache -y
sudo dnf install -y trivy
echo -e "${GREEN}✔ Trivy installed successfully.${NC}"


# ------------------------------------------------------------------------------
# STEP 3: INSTALL ARGOCD
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[STEP 3/4] Deploying ArgoCD to Kubernetes Cluster...${NC}"

# Create dedicated namespace
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Deploy standard official stable manifests
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "${GREEN}✔ ArgoCD core manifests applied to cluster.${NC}"


# ------------------------------------------------------------------------------
# STEP 4: DEPLOY SONARQUBE VIA DOCKER
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[STEP 4/4] Deploying SonarQube Container...${NC}"

# Required kernel configuration parameters for SonarQube's internal database (Elasticsearch)
echo -e "${CYAN}Configuring system virtual memory parameters for SonarQube...${NC}"
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
echo "vm.max_map_count=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.file-max=131072" | sudo tee -a /etc/sysctl.conf

# Spin up standard SonarQube LTS Community Edition
docker run -d \
  --name sonarqube \
  -p 9000:9000 \
  --restart always \
  sonarqube:lts-community

echo -e "${GREEN}✔ SonarQube container started successfully.${NC}"


# ==============================================================================
# INSTALLATION SUMMARY REPORT
# ==============================================================================
echo -e "\n${CYAN}====================================================${NC}"
echo -e "${GREEN}      ALL TOOLS PROVISIONED SUCCESSFULLY            ${NC}"
echo -e "${CYAN}====================================================${NC}"

echo -e "\n${YELLOW}1. TRIVY:${NC} Installed globally (run '${CYAN}trivy --version${NC}' to check)"
echo -e "${YELLOW}2. SONARQUBE:${NC} Access via http://<server-ip>:9000 (Default: admin / admin)"
echo -e "${YELLOW}3. ARGOCD:${NC} Manifests deployed. Get initial admin password by running:"
echo -e "   ${CYAN}kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 --decode; echo${NC}"
echo -e "${CYAN}====================================================${NC}\n"