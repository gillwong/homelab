# Kubernetes Worker Role

Applies configuration for the worker nodes in the Kubernetes cluster.

## Role Variables

The following variables are required unless stated otherwise.

| Variable | Description | Default |
| -- | -- | -- |
| `k8s_worker_cluster_endpoint` | Kubernetes cluster endpoint | - |
| `k8s_worker_join_command` | kubeadm join command | - |
