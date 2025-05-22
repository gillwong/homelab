# Homelab

## Introduction

A collection of infrastructure-as-code (IaC) and configuration-as-code (CaC) files for homelab setup.

[OpenTofu](https://opentofu.org) (an open-source fork of [Terraform](https://developer.hashicorp.com/terraform)) is used to provision infrastructure in [Proxmox Virtual Environment (VE)](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview) through IaC while [Vagrant](https://developer.hashicorp.com/vagrant) is used for testing [Ansible](https://docs.ansible.com) playbooks, which is configuration-as-code used to automate infrastructure configuration.

## Getting Started

The homelab can be configured using either OpenTofu/Terraform or Vagrant. OpenTofu/Terraform is used to provision infrastructure under the `infra/prod` directory while Vagrant is used for provisioning infrastructure under the `infra/test` directory. After provisioning, Ansbile is then used to run playbooks under the `provisioning/playbooks` directory.

### Prerequisites

1. Install IaC tools: OpenTofu ([guide](https://opentofu.org/docs/intro/install/)) or Terraform ([guide](https://developer.hashicorp.com/terraform/install)), and Vagrant ([guide](https://developer.hashicorp.com/vagrant/install))

2. Install CaC tools: Ansible ([guide](https://docs.ansible.com/ansible/latest/getting_started/get_started_ansible.html#get-started-ansible)). There are `requirements.txt` and `.python-version` files under the provisioning directory which can be used if installing Ansible using [pip](https://pypi.org/project/pip/)

### Setup IaC

#### Setup Proxmox

1. Setup a Proxmox VE server ([guide](https://www.proxmox.com/en/products/proxmox-virtual-environment/get-started)) and follow [this guide](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md) to create user for the Terraform Proxmox VE provider

2. Create a Proxmox VE VM template using [this guide](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/guides/cloud-init%20getting%20started.md). The homelab uses [AlmaLinux OS](https://almalinux.org) 9 (an open-source Linux distribution binary compatible with [RHEL](https://www.redhat.com/en/technologies/linux-platforms/enterprise-linux)) and ID 90x for the VM templates by default. Create one VM template for each Proxmox VE node. Obtain the [cloud-init](https://cloud-init.io) images for AlmaLinux [here](https://wiki.almalinux.org/cloud/Generic-cloud.html). Note that the snippet provided in the guide will be replaced via Ansible later on in this "Getting Started" guide.

3. View the Terraform files and make changes as necessary, e.g., the Proxmox VE API URL for the provider, network and disk settings for the VM, etc. Optionally, create an `.auto.tfvars` file to store [variables](https://opentofu.org/docs/language/values/variables/#variable-definitions-tfvars-files)

#### Setup Vagrant

1. Install [Vagrant Libvirt](https://vagrant-libvirt.github.io/vagrant-libvirt/) using [this guide](https://vagrant-libvirt.github.io/vagrant-libvirt/installation.html)

### Setup CaC

1. Add a generic password to the macOS keychain:

```bash
security add-generic-password -s homelab-playbooks -a ansible-vault -w
```

2. Replace all `vault.yaml` files and encrypt them using [Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/vault.html#ansible-vault)

3. View the inventory file `hosts-prod.yaml` and make changes as necessary

4. View variables under the `provisioning/group_vars/` directory and make changes as necessary

### Provisioning

#### Using OpenTofu/Terraform

Provision infrastructure using OpenTofu (replace `tofu` with `terraform` if using Terraform). Example:

```bash
cd infra/prod/k8s
tofu init
tofu plan -out=plan0
tofu apply plan0
```

Bootstrap using the Ansible playbooks. Example:

> [!NOTE]
> Copy all SSH hosts keys to `~/.ssh/known_hosts` before running the playbooks (adjust IP address range to match your environment):
>
> ```bash
> for ip in 192.168.1.{21..26}; do ssh-keyscan -H $ip >> ~/.ssh/known_hosts; done
> ```

```bash
cd ../../../provisioning
ansible-playbook playbooks/k8s.yaml --inventory=hosts-prod.yaml
```

#### Using Vagrant

Provision infrastructure using Vagrant (automatically runs the Ansible playbooks). Example:

```bash
cd infra/test/k8s
vagrant up
```

### Destroying

Destroy infrastructure using OpenTofu (replace `tofu` with `terraform` if using Terraform). Example:

```bash
cd infra/prod/k8s
tofu destroy
```

Or using Vagrant:

```bash
cd infra/test/k8s
vagrant destroy
```
