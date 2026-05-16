# Homelab

> Personal homelab running on a Lenovo ThinkCentre M720q Tiny (i5-8500 · 16GB RAM · 256GB NVMe)

## Goals
- To make everything as automatic as possible (no manual work)
- To make everything declerative (ArgoCD, Terraform, Ansible)
- For my personal study and enjoyment
- Security best practices
- Actually use some of the apps I installed

## Architecture

![Architecture Diagram](https://github.com/user-attachments/assets/c88b60ac-ce99-4ced-8009-3c0ec2858bb6)

| Layer | Technology |
|-------|------------|
| Hypervisor | Proxmox |
| VMs | Ubuntu Server (K3s nodes) · Home Assistant OS |
| Kubernetes | K3s - 1 master + 2 workers |
| GitOps | ArgoCD |
| Ingress | Caddy (Proxmox-level) |
| VPN | Tailscale |

## Getting Started

See [docs/installation-guide.md](docs/installation-guide.md) for the full setup walkthrough.

## FAQ

See [docs/FAQ.md](docs/FAQ.md) for common tasks and troubleshooting.
