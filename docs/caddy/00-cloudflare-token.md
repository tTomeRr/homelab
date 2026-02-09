# Creating a Cloudflare API Token

Caddy uses the Cloudflare DNS plugin for ACME DNS challenges. This requires an API token with DNS edit permissions.

---

## Steps

1. Go to [Cloudflare Dashboard > API Tokens](https://dash.cloudflare.com/profile/api-tokens)
2. Click **Create Token**
3. Use the **Edit zone DNS** template, or create a custom token with:
   - **Permissions**: Zone > DNS > Edit
   - **Zone Resources**: Include > Specific zone > `your-domain.com`
4. Click **Continue to summary**, then **Create Token**
5. Copy the token and encrypt it into the vault:

```bash
cd infrastructure/ansible/proxmox
ansible-vault encrypt_string '<your-cf-token>' --name 'cf_token' > group_vars/all/vault.yml
```
