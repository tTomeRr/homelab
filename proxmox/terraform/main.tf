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

resource "proxmox_vm_qemu" "k3s_master" {
  name        = "k3s-master"
  target_node = var.proxmox_node
  clone       = var.template_name
  agent       = 1
  os_type     = "cloud-init"

  cpu {
    cores = 2
    type  = "host"
  }
  memory = 4096

  boot = "order=virtio0"

  disks {
    virtio {
      virtio0 {
        disk {
          storage = var.storage_name
          size    = 40
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

  ipconfig0 = "ip=192.168.100.110/24,gw=192.168.100.1"
  sshkeys   = var.ssh_public_key
  cicustom  = "vendor=local:snippets/ubuntu.yaml"
}

resource "proxmox_vm_qemu" "k3s_worker01" {
  name        = "k3s-worker01"
  target_node = var.proxmox_node
  clone       = var.template_name
  agent       = 1
  os_type     = "cloud-init"

  cpu {
    cores = 2
    type  = "host"
  }
  memory = 6144

  boot = "order=virtio0"

  disks {
    virtio {
      virtio0 {
        disk {
          storage = var.storage_name
          size    = 50
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

  ipconfig0 = "ip=192.168.100.111/24,gw=192.168.100.1"
  sshkeys   = var.ssh_public_key
  cicustom  = "vendor=local:snippets/ubuntu.yaml"
}

resource "proxmox_vm_qemu" "k3s_worker02" {
  name        = "k3s-worker02"
  target_node = var.proxmox_node
  clone       = var.template_name
  agent       = 1
  os_type     = "cloud-init"

  cpu {
    cores = 2
    type  = "host"
  }
  memory = 6144

  boot = "order=virtio0"

  disks {
    virtio {
      virtio0 {
        disk {
          storage = var.storage_name
          size    = 50
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

  ipconfig0 = "ip=192.168.100.112/24,gw=192.168.100.1"
  sshkeys   = var.ssh_public_key
  cicustom  = "vendor=local:snippets/ubuntu.yaml"
}
