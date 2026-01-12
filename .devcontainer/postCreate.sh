
#!/usr/bin/env bash
set -euo pipefail

# Paths
KIND_CONFIG="/usr/local/share/ckad/kind-config.yaml"
SANITY="/usr/local/share/ckad/scripts/k8s_sanity.sh"

echo "[postCreate] Starting cluster setup..."

# Ensure Docker is up (Codespaces provides Docker-in-Docker with privileged container)
echo "[postCreate] Creating kind cluster 'ckad'..."
kind create cluster --name ckad --config "${KIND_CONFIG}" || {
  echo "[postCreate] Cluster already exists. Skipping."
}

# Set kubeconfig location
mkdir -p "${HOME}/.kube"
kind get kubeconfig --name ckad > "${HOME}/.kube/config"

# Sanity check and base namespace
bash "${SANITY}"

echo "[postCreate] Done ✅"
