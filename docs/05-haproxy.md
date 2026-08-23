# 05 — HAProxy

HAProxy provides a stable API endpoint in front of the three Kubernetes API servers.

## Load Balancer

```text
Hostname : learn-k8s-lb
IP       : 10.10.1.224
Port     : 6443/TCP
```

## Backends

```text
learn-k8s-cp   10.10.1.218:6443
learn-k8s-cp1  10.10.1.222:6443
learn-k8s-cp2  10.10.1.223:6443
```

## Installation Script

```text
scripts/setup-haproxy-k8s.sh
```

Run on `learn-k8s-lb`:

```bash
sudo ./scripts/setup-haproxy-k8s.sh
```

## Verify

```bash
sudo haproxy -c -f /etc/haproxy/haproxy.cfg
sudo systemctl status haproxy --no-pager
ss -lntp | grep 6443
```

The Kubernetes control-plane endpoint used by kubeadm is:

```text
10.10.1.224:6443
```
