# 09 — Workload Tests

This section will document workload behavior.

Planned topics:

- Deployments
- ReplicaSets
- Pod scheduling
- Scaling
- Services
- Self-healing
- Pod deletion and recreation

Initial nginx example:

```bash
kubectl create deployment nginx --image=nginx
kubectl scale deployment nginx --replicas=2
kubectl get pods -o wide
```

Self-healing test:

```bash
kubectl delete pod <nginx-pod-name>
kubectl get pods -w
```

Kubernetes should create a replacement Pod to maintain the desired replica count.
