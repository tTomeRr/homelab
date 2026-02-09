# K3s Cluster Deployment

## Prerequisites

- VMs provisioned via [Terraform](../proxmox/02-install-vms.md)
- SSH access to all nodes (verify with `ansible -m ping all`)
- Vault password file created (see [01-deploy-caddy.md](01-deploy-caddy.md#1-create-vault-password-file) — same step for both playbooks)

---

## 1. Generate Inventory

From the Terraform directory:

```bash
terraform output -raw ansible_inventory > ../../ansible/k3s/inventory.ini
```

---

## 2. Install Dependencies

```bash
ansible-galaxy collection install -r requirements.yml
```

---

## 3. Encrypt K3s Token

```bash
K3S_TOKEN=$(openssl rand -base64 64)
cd infrastructure/ansible/k3s
ansible-vault encrypt_string "$K3S_TOKEN" --name 'token' > group_vars/k3s_cluster/vault.yml
```

---

## 4. Validate Connectivity

```bash
ansible -m ping all
```

---

## 5. Deploy

```bash
ansible-playbook main.yaml
```

Run specific tags:

```bash
ansible-playbook main.yaml --tags init  # Init only
ansible-playbook main.yaml --tags k3s   # K3s only
```

---

## 6. Verify Cluster

```bash
ssh ubuntu@<master-ip> "sudo kubectl get nodes"
```
