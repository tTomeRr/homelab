# Tomer's Homelab

This is my personal Homelab I currently run in my home. 
The goals of this homelab are:
    - To make everything as automatic as possible (no manual work)
    - To make everything declerative
    - For my personal study and enjoyment

## Architecture

| Layer | Technology |
|-------|-----------|
| Hypervisor | Proxmox |
| VMs | Ubuntu (provisioned via Terraform on Proxmox) |
| Kubernetes | K3s (1 master + 2 workers) |
| GitOps | ArgoCD |
| Ingress | Caddy (Proxmox) |

See [docs/architecture.md](docs/architecture.md) for full details.

## Applications

| Application | Installed On | Description | Docs |
|-------------|-------------|-------------|------|
| [Homepage](https://github.com/gethomepage/homepage) | K3s | Dashboard | [docs](docs/homepage/00-troubleshooting.md) |
| [qBittorrent](https://github.com/qbittorrent/qBittorrent) | K3s | Torrent client | [docs](docs/qbittorrent/00-troubleshooting.md) |
| [ArgoCD](https://github.com/argoproj/argo-cd) | K3s | GitOps | [docs](docs/argocd/00-troubleshooting.md) |
| [Caddy](https://github.com/caddyserver/caddy) | Proxmox | Reverse proxy | [docs](docs/caddy/README.md) |
| [AdGuard Home](https://github.com/AdguardTeam/AdGuardHome) | Proxmox | DNS filtering / ad blocking | [docs](docs/adguard/README.md) |


## Getting Started

See [docs/installation-guide.md](docs/installation-guide.md) for the full setup walkthrough.

## FAQ

See [docs/FAQ.md](docs/FAQ.md) for common tasks
