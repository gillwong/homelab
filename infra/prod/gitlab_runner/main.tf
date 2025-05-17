terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

variable "pm_password" {
  description = "Proxmox password for user terraform-prov@pve"
  type        = string
  sensitive   = true
  nullable    = false
}

variable "ci_sshkey" {
  description = "SSH public key for cloudinit"
  type        = string
  sensitive   = true
  nullable    = false
}

provider "proxmox" {
  pm_api_url  = "https://pve.gillwong.com/api2/json" # URL to the Proxmox VE server
  pm_user     = "terraform-prov@pve"
  pm_password = var.pm_password
}

resource "proxmox_vm_qemu" "gitlab_runner" {
  vmid             = 110
  name             = "tf-gitlab-runner"
  target_node      = "pve"
  agent            = 1
  cores            = 4
  memory           = 8192
  boot             = "order=scsi0"                             # has to be the same as the OS disk of the template
  clone            = "AlmaLinux-9-5-20241120-x86-64-cloudinit" # The name of the template
  scsihw           = "virtio-scsi-single"
  vm_state         = "running"
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/dnf-template.yml" # /var/lib/vz/snippets/dnf-template.yml
  ciupgrade  = true
  nameserver = "192.168.0.1"                       # router IP
  ipconfig0  = "ip=192.168.1.10/16,gw=192.168.0.1" # gateway set to router IP
  skip_ipv6  = true
  ciuser     = "almalinux" # Default user, reference: https://wiki.almalinux.org/cloud/Generic-cloud-on-local.html#cloud-init
  sshkeys    = var.ci_sshkey

  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = "local-lvm"
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size       = "32G"
          discard    = true
          emulatessd = true
          iothread   = true
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide1 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id     = 0
    bridge = "vmbr0"
    model  = "virtio"
  }
}