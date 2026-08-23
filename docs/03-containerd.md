# 03 — containerd

containerd is used as the Kubernetes container runtime.

## Installation

The repository includes:

```text
scripts/install-containerd.sh
```

Run:

```bash
sudo ./scripts/install-containerd.sh
```

## Required Configuration

Kubernetes should use the systemd cgroup driver.

Verify:

```bash
grep -n "SystemdCgroup" /etc/containerd/config.toml
```

Expected:

```text
SystemdCgroup = true
```

Check runtime status:

```bash
containerd --version
systemctl is-active containerd
```

Expected:

```text
active
```
