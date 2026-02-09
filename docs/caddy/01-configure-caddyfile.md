# Configuring the Caddyfile Template

The Caddyfile template at `infrastructure/ansible/proxmox/roles/caddy/templates/Caddyfile.j2` defines the reverse proxy rules deployed to the Proxmox host.

---

## Set the Proxmox Tailscale IP

The wildcard entry `*.example.com` forwards traffic to the K3s master node. Update the IP to match The K3S Master node machine's IP address:

```
{
	acme_dns cloudflare {{ cf_token }}
}

proxmox.example.com {
	reverse_proxy localhost:8006 {
		transport http {
			tls_insecure_skip_verify
		}
	}
}

adguard.example.com {
	reverse_proxy localhost:80 {
	}
}

*.example.com {
	reverse_proxy <k3s_master_node_vm_ip>:80 {
	}
}
```

