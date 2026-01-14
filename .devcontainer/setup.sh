#!/bin/bash
set -e

# Install kubectl
curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Create cluster
k3d cluster create practice --agents 2 --wait

# Optional: install k9s
curl -Lo k9s.tar.gz https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz
tar -xzf k9s.tar.gz k9s
sudo mv k9s /usr/local/bin/

echo "Cluster ready! Run: kubectl get nodes"
