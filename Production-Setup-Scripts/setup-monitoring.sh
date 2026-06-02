cat <<'EOF' > setup_monitoring.sh
#!/bin/bash

# ==============================================================================
# MONITORING SETUP SCRIPT (PROMETHEUS & GRAFANA)
# ==============================================================================

# Exit on any error
set -e

echo "[1/5] Preparing RHEL host directories and firewall..."
sudo mkdir -p /mnt/data/prometheus
sudo chown -R 65534:65534 /mnt/data/prometheus
sudo chmod -R 775 /mnt/data/prometheus

if command -v firewall-cmd >/dev/null 2>&1; then
    sudo firewall-cmd --permanent --add-port=30000/tcp >/dev/null 2>&1
    sudo firewall-cmd --reload >/dev/null 2>&1
fi

echo "[2/5] Creating Kubernetes manifest file..."
cat <<K8S_EOF > monitoring-manifests.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitoring
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources: ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
  verbs: ["get", "list", "watch"]
- nonResourceURLs: ["/metrics"]
  verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: monitoring
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-server-conf
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
    scrape_configs:
      - job_name: 'kubernetes-nodes'
        kubernetes_sd_configs:
          - role: node
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: prometheus-pv
spec:
  capacity:
    storage: 5Gi
  accessModes: ["ReadWriteOnce"]
  hostPath:
    path: /mnt/data/prometheus
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-pvc
  namespace: monitoring
spec:
  accessModes: ["ReadWriteOnce"]
  resources:
    requests:
      storage: 5Gi
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus-service
  namespace: monitoring
spec:
  selector:
    app: prometheus-server
  ports:
    - port: 9090
      targetPort: 9090
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring
spec:
  selector:
    app: grafana
  type: NodePort
  ports:
    - port: 3000
      nodePort: 30000
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-deployment
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus-server
  template:
    metadata:
      labels:
        app: prometheus-server
    spec:
      serviceAccountName: prometheus
      containers:
        - name: prometheus
          image: prom/prometheus:v2.45.0
          args:
            - "--config.file=/etc/prometheus/prometheus.yml"
            - "--storage.tsdb.path=/prometheus/"
            - "--storage.tsdb.retention.time=1d"
          resources:
            limits: { memory: 512Mi }
            requests: { memory: 256Mi }
          volumeMounts:
            - name: config-volume
              mountPath: /etc/prometheus/
            - name: storage-volume
              mountPath: /prometheus/
      volumes:
        - name: config-volume
          configMap: { name: prometheus-server-conf }
        - name: storage-volume
          persistentVolumeClaim: { claimName: prometheus-pvc }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        resources:
          limits: { memory: 512Mi }
          requests: { memory: 256Mi }
K8S_EOF

echo "[3/5] Applying manifests..."
kubectl apply -f monitoring-manifests.yaml

echo "[4/5] Cleaning up old failed pods..."
kubectl delete pods -n monitoring --field-selector status.phase!=Running || true

echo "[5/5] Done! Access Grafana at port 30000."
EOF

chmod +x setup_monitoring.sh