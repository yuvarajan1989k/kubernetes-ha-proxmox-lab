# 02 — OS Preparation

Run the OS preparation on all six Kubernetes nodes.

## Host Resolution

Add the following entries to `/etc/hosts` on all Kubernetes nodes and the load balancer:

```text
10.10.1.218  learn-k8s-cp
10.10.1.219  learn-k8s-w1
10.10.1.220  learn-k8s-w2
10.10.1.221  learn-k8s-w3
10.10.1.222  learn-k8s-cp1
10.10.1.223  learn-k8s-cp2
10.10.1.224  learn-k8s-lb
```

Verify:

```bash
getent hosts learn-k8s-cp
getent hosts learn-k8s-cp1
getent hosts learn-k8s-cp2
getent hosts learn-k8s-w1
getent hosts learn-k8s-w2
getent hosts learn-k8s-w3
getent hosts learn-k8s-lb
```

## Disable Swap

Disable active swap:

```bash
sudo swapoff -a
```

Ensure any persistent swap entry is disabled in `/etc/fstab`.

Verify:

```bash
swapon --show
```

No output means swap is disabled.

## Kernel Modules

Create:

```bash
sudo tee /etc/modules-load.d/k8s.conf >/dev/null <<'EOF'
overlay
br_netfilter
EOF
```

Load modules:

```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```

## sysctl Settings

```bash
sudo tee /etc/sysctl.d/k8s.conf >/dev/null <<'EOF'
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
```

Apply:

```bash
sudo sysctl --system
```

Verify:

```bash
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.bridge.bridge-nf-call-ip6tables
sysctl net.ipv4.ip_forward
```
