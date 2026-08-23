#!/bin/bash

set -e

echo "=== Kubernetes OS preparation ==="

echo "[1/4] Disabling swap..."
swapoff -a

echo "[2/4] Configuring kernel modules..."
cat <<EOF >/etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

echo "[3/4] Configuring sysctl settings..."
cat <<EOF >/etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

echo "[4/4] Verification..."

echo
echo "Swap:"
swapon --show || true

echo
echo "Kernel modules:"
lsmod | grep -E 'overlay|br_netfilter'

echo
echo "Sysctl:"
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.bridge.bridge-nf-call-ip6tables
sysctl net.ipv4.ip_forward

echo
echo "=== Kubernetes OS preparation completed ==="
