# AdGuard Home on Proxmox Deployment

## Prerequisites

- SSH access to the Proxmox host
- Caddy already deployed (to avoid port conflicts during setup)

---

## 1. Deploy

```bash
cd infrastructure/ansible/proxmox
ansible-playbook main.yaml --tags adguard
```

This installs AdGuard Home to `/opt/AdGuardHome` and registers it as a systemd service.

---

## 2. Post-Installation Setup

After deployment, complete the [AdGuard Home Post-Installation Setup](../adguard/00-post-install-setup.md).
