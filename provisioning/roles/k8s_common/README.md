# Kubernetes Common Role

Applies common configuration for all nodes in the Kubernetes cluster.

## Role Variables

The following variables are required unless stated otherwise.

| Variable | Description | Default |
| -- | -- | -- |
| `k8s_common_download_dir` | Download directory in localhost (Ansible control node) for all downloads | - |
| `k8s_common_runc_version` | [runc](https://github.com/opencontainers/runc) version | `1.3.0` |
| `k8s_common_url` | runc download URL | `https://github.com/opencontainers/runc/releases/download/v{{ k8s_common_runc_version }}/runc.amd64`  |
| `k8s_common_containerd_version` | [containerd](https://containerd.io) version | `2.1.1` |
| `k8s_common_containerd_archive` | containerd archive file name | `containerd-{{ k8s_common_containerd_version }}-linux-amd64.tar.gz` |
| `k8s_common_containerd_url` | containerd archive download URL | `https://github.com/containerd/containerd/releases/download/v{{ k8s_common_containerd_version }}/{{ k8s_common_containerd_archive }}` |
| `k8s_common_containerd_service_url` | containerd service file download URL | `https://raw.githubusercontent.com/containerd/containerd/main/containerd.service` |
| `k8s_common_cni_plugins_version` | [CNI plugins](https://github.com/containernetworking/plugins) version | `1.7.1` |
| `k8s_common_cni_plugins_archive` | CNI plugins archive file name | `cni-plugins-linux-amd64-v{{ k8s_common_cni_plugins_version }}.tgz` |
| `k8s_common_cni_plugins_url` | CNI plugins archive download URL | `https://github.com/containernetworking/plugins/releases/download/v{{ k8s_common_cni_plugins_version }}/{{ k8s_common_cni_plugins_archive }}` |
| `k8s_common_crictl_version` | [crictl](https://github.com/kubernetes-sigs/cri-tools) version | `1.33.0` |
| `k8s_common_crictl_archive` | crictl archive file name | `crictl-v{{ k8s_common_crictl_version }}-linux-amd64.tar.gz` |
| `k8s_common_version` | Kubernetes tools (kubelet, kubeadm, kubectl) version | `1.33.1` |
| `k8s_common_common_base_url` | Kubernetes tools download base URL | `https://dl.k8s.io/release/v{{ k8s_common_version }}/bin/linux/amd64` |
| `k8s_common_kubelet_version` | kubelet service files version. Learn more [here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl) | `0.16.2` |
| `k8s_common_kubelet_base_url` | kubelet service files download base URL | `https://raw.githubusercontent.com/kubernetes/release/v{{ k8s_common_kubelet_version }}/cmd/krel/templates/latest` |
| `k8s_common_kubelet_service_url` | kubelet service file download URL | `"{{ k8s_common_kubelet_base_url }}/kubelet/kubelet.service"` |
| `k8s_common_kubelet_config_url` | kubelet service file for kubeadm download URL | `"{{ k8s_common_kubelet_base_url }}/kubeadm/10-kubeadm.conf"` |
| `k8s_common_storage` | Kubernetes storage provider. Options: `openebs`, `longhorn` | `openebs` |
