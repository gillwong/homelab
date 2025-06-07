resource "proxmox_vm_qemu" "k8s_cp_1" {
  target_node      = "pve1"
  clone            = "almalinux-9-6-x86-64-cloudinit" # The name of the template
  vmid             = 121
  name             = "k8s-cp-1"
  agent            = 1
  bios             = "ovmf"
  scsihw           = "virtio-scsi-single"
  boot             = "order=scsi0" # has to be the same as the OS disk of the template
  memory           = 6144
  balloon          = 6144
  vm_state         = "running"
  onboot           = true
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/dnf_template.yaml" # /var/lib/vz/snippets/dnf_template.yaml
  ciupgrade  = true
  nameserver = "192.168.0.1"                        # router IP
  ipconfig0  = "ip=192.168.0.131/24,gw=192.168.0.1" # gateway set to router IP
  skip_ipv6  = true
  ciuser     = "almalinux" # Default user, reference: https://wiki.almalinux.org/cloud/Generic-cloud-on-local.html#cloud-init
  sshkeys    = var.ci_sshkey

  cpu {
    cores = 4
  }

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
          size       = "256G"
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

  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }
}

resource "proxmox_vm_qemu" "k8s_cp_2" {
  target_node      = "pve2"
  clone            = "almalinux-9-6-x86-64-cloudinit" # The name of the template
  vmid             = 122
  name             = "k8s-cp-2"
  agent            = 1
  bios             = "ovmf"
  scsihw           = "virtio-scsi-single"
  boot             = "order=scsi0" # has to be the same as the OS disk of the template
  memory           = 6144
  balloon          = 6144
  vm_state         = "running"
  onboot           = true
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/dnf_template.yaml" # /var/lib/vz/snippets/dnf_template.yaml
  ciupgrade  = true
  nameserver = "192.168.0.1"                        # router IP
  ipconfig0  = "ip=192.168.0.132/24,gw=192.168.0.1" # gateway set to router IP
  skip_ipv6  = true
  ciuser     = "almalinux" # Default user, reference: https://wiki.almalinux.org/cloud/Generic-cloud-on-local.html#cloud-init
  sshkeys    = var.ci_sshkey

  cpu {
    cores = 4
  }

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
          size       = "256G"
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

  efidisk {
    efitype = "4m"
    storage = "local-lvm"
  }
}

# resource "proxmox_vm_qemu" "k8s_cp_3" {
#   target_node      = "pve3"
#   clone            = "almalinux-9-6-x86-64-cloudinit" # The name of the template
#   vmid             = 123
#   name             = "k8s-cp-3"
#   agent            = 1
#   bios             = "ovmf"
#   scsihw           = "virtio-scsi-single"
#   boot             = "order=scsi0" # has to be the same as the OS disk of the template
#   memory           = 6144
#   balloon          = 6144
#   vm_state         = "running"
#   onboot           = true
#   automatic_reboot = true

#   # Cloud-Init configuration
#   cicustom   = "vendor=local:snippets/dnf_template.yaml" # /var/lib/vz/snippets/dnf_template.yaml
#   ciupgrade  = true
#   nameserver = "192.168.0.1"                        # router IP
#   ipconfig0  = "ip=192.168.0.133/24,gw=192.168.0.1" # gateway set to router IP
#   skip_ipv6  = true
#   ciuser     = "almalinux" # Default user, reference: https://wiki.almalinux.org/cloud/Generic-cloud-on-local.html#cloud-init
#   sshkeys    = var.ci_sshkey

#   cpu {
#     cores = 4
#   }

#   # Most cloud-init images require a serial device for their display
#   serial {
#     id = 0
#   }

#   disks {
#     scsi {
#       scsi0 {
#         # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
#         disk {
#           storage = "local-lvm"
#           # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
#           size       = "256G"
#           discard    = true
#           emulatessd = true
#           iothread   = true
#         }
#       }
#     }
#     ide {
#       # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
#       ide1 {
#         cloudinit {
#           storage = "local-lvm"
#         }
#       }
#     }
#   }

#   network {
#     id     = 0
#     bridge = "vmbr0"
#     model  = "virtio"
#   }

#   efidisk {
#     efitype = "4m"
#     storage = "local-lvm"
#   }
# }