terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc01"
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
  pm_api_url  = "https://192.168.0.11:8006/api2/json" # URL to the Proxmox VE server
  pm_user     = "terraform-prov@pve"
  pm_password = var.pm_password
}
