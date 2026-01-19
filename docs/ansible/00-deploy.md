# K3s Cluster Deployment

## Prerequisites

- VMs provisioned via Terraform
- SSH access to all nodes

---

## 1. Generate Inventory

From the Terraform directory:

```bash
terraform output -raw ansible_inventory > ../../ansible/inventory.ini
```

---

## 2. Install Dependencies

```bash
ansible-galaxy collection install -r requirements.yml
```

---

## 3. Validate Connectivity

```bash
ansible -m ping all -i inventory.ini
```

---

## 4. Deploy

```bash
K3S_TOKEN=<your-secret-token> ansible-playbook main.yaml -i inventory.ini
```

Run specific tags:

```bash
ansible-playbook main.yaml -i inventory.ini --tags init  # Init only
ansible-playbook main.yaml -i inventory.ini --tags k3s   # K3s only
```

---

## 5. Verify Cluster

```bash
ssh ubuntu@<master-ip> "sudo kubectl get nodes"
```
