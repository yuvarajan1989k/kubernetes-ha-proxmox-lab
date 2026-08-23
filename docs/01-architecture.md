# 01 — Architecture

## Objective

Build a highly available Kubernetes lab on Proxmox with three control-plane nodes, three worker nodes, and a dedicated HAProxy load balancer.

## Topology

```text
                         Kubernetes API
                         10.10.1.224:6443
                                |
                         learn-k8s-lb
                            HAProxy
                                |
              +-----------------+-----------------+
              |                 |                 |
       learn-k8s-cp       learn-k8s-cp1     learn-k8s-cp2
       10.10.1.218        10.10.1.222       10.10.1.223
       Control Plane      Control Plane      Control Plane
              |
       Kubernetes Cluster
              |
       +------+------+ 
       |      |      |
learn-k8s-w1 learn-k8s-w2 learn-k8s-w3
10.10.1.219  10.10.1.220  10.10.1.221
```

## Node Inventory

| Hostname | Role | IP |
|---|---|---|
| `learn-k8s-cp` | Control Plane | `10.10.1.218` |
| `learn-k8s-cp1` | Control Plane | `10.10.1.222` |
| `learn-k8s-cp2` | Control Plane | `10.10.1.223` |
| `learn-k8s-w1` | Worker | `10.10.1.219` |
| `learn-k8s-w2` | Worker | `10.10.1.220` |
| `learn-k8s-w3` | Worker | `10.10.1.221` |
| `learn-k8s-lb` | HAProxy | `10.10.1.224` |

## Network Plan

```text
Node Network        : 10.10.1.0/24
Service CIDR        : 10.96.0.0/12
Cilium Pod CIDR     : 172.20.0.0/16
Per-node Pod CIDR   : /24
API Endpoint        : 10.10.1.224:6443
```

The node network, Service network, and Pod network are intentionally separated to avoid routing conflicts.
