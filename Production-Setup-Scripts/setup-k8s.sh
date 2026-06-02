#!/bin/bash

# Exit on any error
set -e

echo "------------------------------------------------"
echo " Starting Kubernetes Setup for RHEL 8.10"
echo " IP: 172.16.39.20 | Role: Master & Worker"
echo "------------------------------------------------"

# 1. System Prerequisites
echo "[1/8] Disabling Swap and setting SELinux to Permissive..."
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# 2. Kernel Modules
echo "[2/8] Loading kernel modules..."
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system

# 3. Firewall Configuration (Keeping it ON as requested)
echo "[3/8] Opening Firewall ports for K8s and App..."
firewall-cmd --permanent --add-port=6443/tcp    # API Server
firewall-cmd --permanent --add-port=2379-2380/tcp # etcd
firewall-cmd --permanent --add-port=10250/tcp   # Kubelet
firewall-cmd --permanent --add-port=10257/tcp   # Controller Manager
firewall-cmd --permanent --add-port=10259/tcp   # Scheduler
firewall-cmd --permanent --add-port=30080/tcp   # Frontend App
firewall-cmd --permanent --add-port=179/tcp     # Calico BGP
firewall-cmd --permanent --add-port=4789/udp    # Calico VXLAN
firewall-cmd --permanent --add-masquerade
firewall-cmd --reload

# 4. Containerd Runtime
echo "[4/8] Configuring Containerd..."
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# 5. Install K8s Components (v1.30)
echo "[5/8] Installing kubeadm, kubelet, kubectl..."
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
EOF

dnf install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

# 6. Initialize Cluster
echo "[6/8] Initializing Cluster (Pod CIDR 192.168.0.0/16)..."
# Using ignore-preflight-errors for memory since 3GB is below recommended 4GB
kubeadm init --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=Mem

# Setup Kubeconfig for root
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Allow pods to run on Master (Single Node setup)
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true
kubectl taint nodes --all node-role.kubernetes.io/master- || true

# 7. Install Calico Networking
echo "[7/8] Installing Calico Networking..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

# 8. Deploy Application
echo "[8/8] Deploying Printing Service App..."
cat <<EOF > printing-app.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: printing-service
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: printing-service
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: rakibecb/ecb-printing-service-backend:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 7235
---
apiVersion: v1
kind: Service
metadata:
  name: backend
  namespace: printing-service
spec:
  selector:
    app: backend
  ports:
  - protocol: TCP
    port: 7235
    targetPort: 7235
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: printing-service
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: rakibecb/ecb-printing-service-frontend:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: printing-service
spec:
  type: NodePort
  selector:
    app: frontend
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080
EOF

kubectl apply -f printing-app.yaml

echo "------------------------------------------------"
echo " SETUP COMPLETE!"
echo " Check pods: kubectl get pods -n printing-service"
echo " Access App: http://172.16.39.20:30080"
echo "------------------------------------------------"