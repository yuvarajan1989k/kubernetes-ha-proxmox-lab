#!/bin/bash
set -euo pipefail

echo "=== Installing containerd ==="

apt-get update
apt-get install -y containerd

echo "=== Creating default containerd configuration ==="

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

echo "=== Enabling SystemdCgroup ==="

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

echo "=== Restarting containerd ==="

systemctl restart containerd
systemctl enable containerd

echo "=== Verification ==="

containerd --version
systemctl is-active containerd
grep -n "SystemdCgroup" /etc/containerd/config.toml

echo "=== containerd setup completed ==="
