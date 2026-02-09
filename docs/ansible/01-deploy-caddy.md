# Caddy on Proxmox Deployment

## Prerequisites

- SSH access to the Proxmox host
- [Cloudflare API token created](../caddy/00-cloudflare-token.md)
- [Caddyfile template configured with Proxmox Tailscale IP](../caddy/01-configure-caddyfile.md)

---

## 1. Create Vault Password File

This is a one-time setup shared by all playbooks:

```bash
echo 'your-password' > ~/.vault_password
chmod 600 ~/.vault_password
```

---

## 2. Encrypt Cloudflare Token

```bash
cd infrastructure/ansible/proxmox
ansible-vault encrypt_string '<your-cf-token>' --name 'cf_token' > group_vars/all/vault.yml
```

---

## 3. Deploy

```bash
cd infrastructure/ansible/proxmox
ansible-playbook main.yaml
```
