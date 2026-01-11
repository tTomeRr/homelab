terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc07"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true
}

locals {
  k3s_vms = {
    "k3s-master" = {
      memory    = 4096
      disk_size = 40
      ip        = "192.168.100.110"
    }
    "k3s-worker01" = {
      memory    = 6144
      disk_size = 50
      ip        = "192.168.100.111"
    }
    "k3s-worker02" = {
      memory    = 6144
      disk_size = 50
      ip        = "192.168.100.112"
    }
  }
}

resource "proxmox_vm_qemu" "k3s_cluster" {
  for_each = local.k3s_vms

  name        = each.key
  target_node = var.proxmox_node
  clone       = var.template_name
  agent       = 1
  os_type     = "cloud-init"

  cpu {
    cores = 2
    type  = "host"
  }
  memory = each.value.memory

  boot = "order=virtio0"

  disks {
    virtio {
      virtio0 {
        disk {
          storage = var.storage_name
          size    = each.value.disk_size
        }
      }
    }
    ide {
      ide3 {
        cloudinit {
          storage = var.storage_name
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=${each.value.ip}/24,gw=192.168.100.1"
  sshkeys   = var.ssh_public_key
  cicustom  = "vendor=local:snippets/ubuntu.yaml"
}
