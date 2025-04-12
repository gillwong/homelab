# Homelab

## Introduction

A collection of infrastructure-as-code (IaC) and configuration-as-code (CaC) files for homelab setup.

[OpenTofu](https://opentofu.org) (an open-source fork of [Terraform](https://developer.hashicorp.com/terraform)) is used to provision infrastructure in [Proxmox Virtual Environment (VE)](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) through IaC while [Vagrant](https://developer.hashicorp.com/vagrant) is used for testing infrastructure configurations.

[Ansible](https://docs.ansible.com) is used for configuring the infrastructure after provisioning through CaC.

## Getting Started

The homelab can be configured via Vagrant only or OpenTofu/Terraform only (either is sufficient). Both tools can be installed to utilize Vagrant for testing infrastructure configurations and OpenTofu/Terraform for the deployed infrastructure. Ansible must be installed in all setups.

### Prerequisites

1. Install IaC tools: OpenTofu ([guide](https://opentofu.org/docs/intro/install/)) or Terraform ([guide](https://developer.hashicorp.com/terraform/install)), and Vagrant ([guide](https://developer.hashicorp.com/vagrant/install))

2. Install CaC tools: Ansible ([guide](https://docs.ansible.com/ansible/latest/getting_started/get_started_ansible.html#get-started-ansible)). There are `requirements.txt` and `.python-version` files under the provisioning directory if Ansible is installed via [pip](https://pypi.org/project/pip/)

### Setup IaC

1. Install [Vagrant Libvirt](https://vagrant-libvirt.github.io/vagrant-libvirt/) using [this guide](https://vagrant-libvirt.github.io/vagrant-libvirt/installation.html)

2. Setup a Proxmox VE server ([guide](https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started)) and follow [this guide](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md) to setup the Terraform Proxmox VE provider

3. Create a Proxmox VE VM template using [this guide](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/guides/cloud-init%20getting%20started.md). The homelab uses [AlmaLinux OS](https://almalinux.org) 9.5 (an open-source Linux distribution binary compatible with [RHEL](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)) and ID 900 for the VM template by default. Get the [cloud-init](https://cloud-init.io) images for AlmaLinux [here](https://wiki.almalinux.org/cloud/Generic-cloud.html). Replace the snippet provided in the guide by running:

```bash
tee /var/lib/vz/snippets/qemu-guest-agent.yml << EOF
#cloud-config
runcmd:
  - dnf upgrade -y
  - dnf install -y qemu-guest-agent python
  - systemctl start qemu-guest-agent
EOF
```

4. View the Terraform files and make changes as necessary, e.g., the Proxmox VE API URL for the provider, network and disk settings for the VM, etc. Optionally, create an `.auto.tfvars` file to store [variables](https://opentofu.org/docs/language/values/variables/#variable-definitions-tfvars-files)

### Setup CaC

1. Add a generic password to the macOS keychain:

```bash
security add-generic-password -s homelab-playbooks -a ansible-vault -w
```

2. Replace all `vault.yaml` files. Run the following to encrypt the files:

```bash
ansible-vault encrypt vault.yaml
```

3. View the `hosts-prod.yaml` and make changes as necessary

### Provisioning

#### Using OpenTofu/Terraform

Provision infrastructure using OpenTofu (replace `tofu` with `terraform` if using Terraform):

```bash
cd infra/prod/gitlab_runner
tofu init
tofu plan
tofu apply plan0

cd ../k8s
tofu init
tofu plan
tofu apply plan0
```

Bootstrap using the Ansible playbooks:

> [!NOTE]
> Copy all SSH hosts keys to `~/.ssh/known_hosts` before running the playbooks (adjust IP address range to match your environment):
>
> ```bash
> for ip in 192.168.1.{21..26}; do ssh-keyscan -H $ip >> ~/.ssh/known_hosts; done
> ```

```bash
cd ../../../provisioning
ansible-playbook playbooks/gitlab_runner.yaml --inventory=hosts-prod.yaml
ansible-playbook playbooks/k8s.yaml --inventory=hosts-prod.yaml
```

#### Using Vagrant

Provision infrastructure using Vagrant (automatically runs the Ansible playbooks):

```bash
cd infra/test/gitlab_runner
vagrant up

cd ../k8s
vagrant up
```

### Destroying

Destroy infrastructure using OpenTofu (replace `tofu` with `terraform` if using Terraform):

```bash
cd infra/prod/gitlab_runner
tofu destroy

cd ../k8s
tofu destroy
```

Or using Vagrant:

```bash
cd infra/test/gitlab_runner
vagrant destroy

cd ../k8s
vagrant destroy
```
