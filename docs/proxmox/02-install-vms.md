# Deploying VMs on Proxmox with Terraform

Provision three Ubuntu 24.04 VMs on Proxmox using Terraform and cloud-init for K3s cluster deployment.

**Result:** Three VMs (1 master, 2 workers) with static IPs, ready for K3s installation.

---

## Prerequisites

- Terraform installed locally
- Network: 192.168.100.x subnet with gateway at 192.168.100.1

---

## 1. Create Ubuntu Cloud-Init Template

**Template guide:** [UntouchedWagons/Ubuntu-CloudInit-Docs](https://github.com/UntouchedWagons/Ubuntu-CloudInit-Docs)

SSH to Proxmox host:

```bash
export VMID=9000 STORAGE=local-lvm
curl -fsSL https://raw.githubusercontent.com/UntouchedWagons/Ubuntu-CloudInit-Docs/main/samples/ubuntu/ubuntu-noble-cloudinit.sh | bash
```

**What this does:**
- Downloads Ubuntu 24.04 cloud image
- Creates VM with UEFI, VirtIO disk, and cloud-init
- Auto-installs qemu-guest-agent on first boot
- Converts to template (ID 9000, name: `ubuntu-noble-template`)

---

## 2. Create Proxmox API Token

In Proxmox web UI:

1. **Datacenter** → **Permissions** → **API Tokens** → **Add**
2. Configure:
   - User: `root@pam`
   - Token ID: `terraform`
   - **Uncheck** "Privilege Separation"
3. Copy the secret (shown only once)

**Result:**
- Token ID: `root@pam!terraform`
- Secret: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

**Test access:**
```bash
curl -k -H 'Authorization: PVEAPIToken=root@pam!terraform=YOUR_SECRET' \
  https://YOUR_PROXMOX_IP:8006/api2/json/access/permissions
```

---

## 3. Configure Terraform


Update these values:

- `proxmox_api_url`: Your Proxmox IP (e.g., `https://192.168.100.100:8006/api2/json`)
- `proxmox_node`: Your node name (check: `pvesh get /nodes`)
- `template_name`: `ubuntu-noble-template`
- `storage_name`: Your storage pool
- `ssh_public_key`: Your SSH public key

---

## 4. Deploy VMs

### 4.1 Initialize

```bash
terraform init
```

### 4.2 Set API Credentials

```bash
export TF_VAR_proxmox_token_id='root@pam!terraform'
export TF_VAR_proxmox_token_secret="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
```

### 4.3 Review and Apply

```bash
terraform plan
terraform apply
```

---

## 5. Verify and Access

### Check Status

Proxmox UI shows three running VMs:
- k3s-master (192.168.100.110)
- k3s-worker01 (192.168.100.111)
- k3s-worker02 (192.168.100.112)

### SSH Access

```bash
ssh ubuntu@192.168.100.110  # master
ssh ubuntu@192.168.100.111  # worker01
ssh ubuntu@192.168.100.112  # worker02
```

> **NOTE:** The VMs will not be accessible via Proxmox UI console. Only via SSH

### Generate Ansible Inventory

View the Ansible inventory:

```bash
terraform output -raw ansible_inventory
```

Save it to the inventory file:

```bash
terraform output -raw ansible_inventory > ../../ansible/inventory.ini
```

---
