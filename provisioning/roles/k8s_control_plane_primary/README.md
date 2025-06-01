# Kubernetes Primary Control Plane Role

Applies configuration for the primary control plane node in the Kubernetes cluster, which is the first control node to be initialized using `kubeadm init`.

## Role Variables

The following variables are required unless stated otherwise.

| Variable | Description | Default |
| -- | -- | -- |
| `k8s_control_plane_primary_cluster_endpoint` | Kubernetes cluster endpoint | - |
| `k8s_control_plane_primary_service_subnet` | Kubernetes service subnet CIDR | `10.96.0.0/12` |
| `k8s_control_plane_primary_pod_subnet` | Kubernetes pod subnet CIDR | `10.244.0.0/16` |
| `k8s_control_plane_primary_extra_sans` | Extra SANs for the Kubernetes API server | `k8s.gillwong.com` |
| `k8s_control_plane_primary_tigera_operator_version` | Tigera operator and Calico version | `3.30.0` |
| `k8s_control_plane_primary_tigera_operator_url` | Tigera operator manifests URL | `https://raw.githubusercontent.com/projectcalico/calico/v{{ k8s_control_plane_primary_tigera_operator_version }}/manifests/tigera-operator.yaml` |
