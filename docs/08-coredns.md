# 08 — CoreDNS

This document will cover Kubernetes DNS and service discovery.

## Initial Validation

Check CoreDNS:

```bash
kubectl get pods -n kube-system -l k8s-app=kube-dns -o wide
kubectl get svc -n kube-system kube-dns
```

Inspect a Pod resolver:

```bash
kubectl exec <pod-name> -- cat /etc/resolv.conf
```

Example:

```text
search default.svc.cluster.local svc.cluster.local cluster.local
nameserver 10.96.0.10
options ndots:5
```

Test the Kubernetes Service FQDN:

```bash
kubectl exec <pod-name> -- nslookup kubernetes.default.svc.cluster.local
```

Expected result:

```text
kubernetes.default.svc.cluster.local -> 10.96.0.1
```

