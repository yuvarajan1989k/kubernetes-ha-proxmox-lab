# 07 — Cilium Networking

Cilium provides the Kubernetes CNI networking layer.

## Final IPAM Design

```text
Node Network        : 10.10.1.0/24
Service CIDR        : 10.96.0.0/12
Cilium Pod CIDR     : 172.20.0.0/16
Per-node Pod CIDR   : /24
```

## Install Cilium

```bash
cilium install \
  --version 1.20.1 \
  --set ipam.mode=cluster-pool \
  --set ipam.operator.clusterPoolIPv4PodCIDRList="172.20.0.0/16" \
  --set ipam.operator.clusterPoolIPv4MaskSize=24
```

## Meaning of the IPAM Settings

`ipam.mode=cluster-pool`

Cilium manages Pod IP allocation using a central cluster pool.

`clusterPoolIPv4PodCIDRList=172.20.0.0/16`

Defines the overall IPv4 address pool available for Kubernetes Pods.

`clusterPoolIPv4MaskSize=24`

Allocates a `/24` subnet from the overall pool to each Kubernetes node.

## Verify Cilium

```bash
cilium status
```

Expected:

```text
Cilium:          OK
Operator:        OK
Envoy DaemonSet: OK
```

Check per-node Pod CIDRs:

```bash
kubectl get ciliumnodes \
  -o custom-columns=NAME:.metadata.name,POD-CIDR:.spec.ipam.podCIDRs
```

Example from the control-plane nodes:

```text
learn-k8s-cp    [172.20.2.0/24]
learn-k8s-cp1   [172.20.0.0/24]
learn-k8s-cp2   [172.20.1.0/24]
```

The exact allocation order may differ.

## Important Learning — CIDR Overlap

The initial Cilium installation used the default pool:

```text
10.0.0.0/8
```

The physical Kubernetes node network is:

```text
10.10.1.0/24
```

Because `10.10.1.0/24` is contained within `10.0.0.0/8`, the design had a potential address overlap.

The initial node allocations happened to use:

```text
10.0.0.0/24
10.0.1.0/24
10.0.2.0/24
10.0.3.0/24
10.0.4.0/24
10.0.5.0/24
```

There was no immediate collision, but the overall pool was unsafe.

The cluster was rebuilt with:

```text
172.20.0.0/16
```

This keeps the three network domains separate:

```text
Nodes     : 10.10.1.0/24
Services  : 10.96.0.0/12
Pods      : 172.20.0.0/16
```

## Connectivity Validation

```bash
cilium connectivity test
```

## Connectivity Test Result

Cilium connectivity validation was completed successfully:

```text
All 82 tests (780 actions) successful
50 tests skipped
1 scenario skipped

