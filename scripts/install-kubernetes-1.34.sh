#!/bin/bash
set -euo pipefail

echo "=== Installing Kubernetes v1.34 packages ==="

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gpg

mkdir -p -m 755 /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' \
  > /etc/apt/sources.list.d/kubernetes.list

chmod 644 /etc/apt/sources.list.d/kubernetes.list

apt-get update

apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl

systemctl enable kubelet

echo
echo "=== Installed versions ==="
kubeadm version
kubectl version --client
kubelet --version

echo
echo "=== Package hold status ==="
apt-mark showhold | grep -E 'kubeadm|kubelet|kubectl'

echo
echo "=== Kubernetes package installation completed ==="
