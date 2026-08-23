# 04 — Kubernetes Installation

Install kubeadm, kubelet, and kubectl on all six Kubernetes nodes.

## Version

This lab uses:

```text
Kubernetes v1.34.11
```

## Installation Script

```text
scripts/install-kubernetes-1.34.sh
```

Run:

```bash
sudo ./scripts/install-kubernetes-1.34.sh
```

## Verify

```bash
kubeadm version
kubelet --version
kubectl version --client
```

The packages are held after installation to avoid unplanned version changes:

```bash
apt-mark showhold
```
