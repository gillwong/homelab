# Kubernetes Secondary Control Plane Role

Applies configuration for the secondary control plane nodes in the Kubernetes cluster, which are the nodes joining the cluster as control plane nodes.

## Role Variables

The following variables are required unless stated otherwise.

| Variable | Description | Default |
| -- | -- | -- |
| `k8s_control_plane_secondary_cluster_endpoint` | Kubernetes cluster endpoint | - |
| `k8s_control_plane_secondary_join_command` | kubeadm join command | - |
| `k8s_control_plane_secondary_certificate_key` | Kubernetes certificate key for control plane nodes | - |
