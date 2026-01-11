# Proxmox Post-Installation Guide

This guide covers the essential security hardening and configuration steps to perform immediately after installing Proxmox.

## Table of Contents
1. [Post-Installation Script](#post-installation-script)
2. [SSH Key Setup](#ssh-key-setup)
3. [Security Hardening](#security-hardening)
4. [Automatic Security Updates](#automatic-security-updates)
4. [Enable Two Factor Login](#enable-two-factor-login)

---

## Post-Installation Script

Run the community post-installation script to configure essential settings:
- Disable Enterprise Repo
- Add or correct PVE sources
- Enable No-Subscription Repo
- Update Proxmox VE

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
```

**Source**: [Community Scripts - Post PVE Install](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install)

## SSH Key Setup

### Generate SSH Key (on local machine)
```bash
ssh-keygen -t ed25519 -f ~/.ssh/proxmox
cat ~/.ssh/proxmox.pub  # Copy this output
```

## Security Hardening

### Run Security Script
```bash
ssh root@<proxmox-ip>
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tTomeRr/homelab/main/infrastructure/proxmox/post-install-script.sh -o post-install.sh)"
```

**Steps**:
1. Paste SSH public key when prompted
2. **Save username and sudo password to Bitwarden**
3. Test SSH in new terminal: `ssh -i ~/.ssh/proxmox <username>@<proxmox-ip>`
4. After successful test: `sudo systemctl restart sshd`

## Automatic Security Updates

Follow this guide to enable automatic security updates:
[Proxmox Hardening Guide - Automatic Updates](https://github.com/HomeSecExplorer/Proxmox-Hardening-Guide/blob/main/docs/pve9-hardening-guide.md#113-configure-automatic-security-updates)

### Installation
```bash
apt update && apt install unattended-upgrades apt-listchanges -y
```

### Configuration

#### Configure Update Schedule
Edit `/etc/apt/apt.conf.d/20auto-upgrades`:
```
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
```

#### Configure Update Origins
Edit `/etc/apt/apt.conf.d/50unattended-upgrades`:
```
Unattended-Upgrade::Origins-Pattern {
  "origin=Debian,codename=${distro_codename},label=Debian";
  "origin=Debian,codename=${distro_codename}-security,label=Debian-Security";
  "origin=Debian,codename=${distro_codename},label=Debian-Security";
};
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
```

### Enable Service
```bash
systemctl enable unattended-upgrades
```

### Monitoring
Monitor `/var/log/unattended-upgrades/unattended-upgrades.log` for failures.

---

## Enable Two Factor Login

On Promox UI go to:
```
Datacenter -> Two Factor -> Add
```
Follow the instructions to configure TOTP login using Google Authenticator
