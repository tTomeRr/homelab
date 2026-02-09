# AdGuard Home Post-Installation Setup

## Table of Contents
1. [Access Setup Wizard](#access-setup-wizard)
2. [Configure Admin Interface Port](#configure-admin-interface-port)
3. [Create Admin Account](#create-admin-account)
4. [Configure Router DNS](#configure-router-dns)

---

## Access Setup Wizard

After the Ansible playbook completes, open the AdGuard Home setup wizard:

```
http://[proxmox-ip]:3000
```

Example: `http://192.168.100.100:3000`

---

## Configure Admin Interface Port

Because Caddy already listens on port 80, change the AdGuard admin interface to use port 3000 instead:

1. In the setup wizard, set **Admin Web Interface** listen address to port `3000`
2. Keep the DNS server listen address on port `53` (default)

---

## Create Admin Account

Choose a username and password for the AdGuard Home admin panel.

---

## Configure Router DNS

Point your router's DNS settings to the Proxmox host so all devices on the network use AdGuard Home:

1. Open your router's admin panel
2. Navigate to DNS settings
   - On Xiaomi routers: **Commonly used settings** > **Internet settings** > **Manually configure DNS**
3. Set the primary DNS server to the Proxmox host IP (e.g. `192.168.100.100`)
4. Save changes

> All devices on the network will now use AdGuard Home for DNS resolution and ad blocking.

## Reference Materials
- [AdGuard Home Getting Started Guide](https://adguard-dns.io/kb/adguard-home/getting-started/)
