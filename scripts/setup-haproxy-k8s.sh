#!/bin/bash
set -euo pipefail

echo "=== Installing HAProxy ==="

apt-get update
apt-get install -y haproxy

echo "=== Backing up existing configuration ==="

cp /etc/haproxy/haproxy.cfg \
   /etc/haproxy/haproxy.cfg.bak.$(date +%Y%m%d%H%M%S)

echo "=== Configuring Kubernetes API load balancer ==="

cat > /etc/haproxy/haproxy.cfg <<'EOF'
global
    log /dev/log local0
    log /dev/log local1 notice
    daemon

defaults
    log global
    mode tcp
    option tcplog
    timeout connect 10s
    timeout client  1m
    timeout server  1m

frontend kubernetes-api
    bind *:6443
    mode tcp
    default_backend kubernetes-control-plane

backend kubernetes-control-plane
    mode tcp
    balance roundrobin
    option tcp-check
# change your k8s control plane hostname and ipaddress
    server learn-k8s-cp  10.10.1.218:6443 check
    server learn-k8s-cp1 10.10.1.222:6443 check
    server learn-k8s-cp2 10.10.1.223:6443 check
EOF

echo "=== Validating HAProxy configuration ==="

haproxy -c -f /etc/haproxy/haproxy.cfg

echo "=== Starting HAProxy ==="

systemctl enable --now haproxy
systemctl restart haproxy

echo
echo "=== HAProxy status ==="
systemctl is-active haproxy

echo
echo "=== Listening ports ==="
ss -lntp | grep 6443 || true

echo
echo "=== HAProxy Kubernetes load balancer configured ==="
