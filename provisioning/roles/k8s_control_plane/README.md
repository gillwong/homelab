# Kubernetes Control Plane Role

Applies common configuration for all control plane nodes in the Kubernetes cluster.

## Role Variables

The following variables are required unless stated otherwise.

| Variable | Description | Default |
| -- | -- | -- |
| `k8s_control_plane_cluster_endpoint` | Kubernetes cluster endpoint | - |
| `k8s_control_plane_kube_vip_version` | [kube-vip](https://kube-vip.io) version | `0.9.1` |
