
#!/usr/bin/env bash
set -euo pipefail

echo "== Kubernetes sanity check =="

echo "- kubectl version:"
kubectl version --client

echo "- kind version:"
kind version

echo "- helm version:"
helm version --short

echo "- k9s version:"
k9s version --short || true

echo "- Creating test namespace 'ckad' if missing..."
kubectl get ns ckad >/dev/null 2>&1 || kubectl create ns ckad

echo "- Current context:"
kubectl config current-context

echo "- Switching default namespace to ckad..."
kubectl config set-context --current --namespace=ckad

echo "- Applying a quick test Pod..."
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: ckad-sanity
spec:
  containers:
  - name: pause
    image: registry.k8s.io/pause:3.9
EOF

kubectl wait --for=condition=Ready pod/ckad-sanity --timeout=60s
kubectl get pod ckad-sanity -o wide

echo "Sanity OK ✅"
