## FAQ

**How to add a new app to the cluster?**

1. Create `apps/myapp/` with your manifests inside.
2. Create `apps/myapp.yaml` — copy an existing one (e.g. `apps/homepage.yaml`) and update `name`, `path`, and `namespace`.
3. `kubectl apply -f apps/myapp.yaml`

---

**How to temporarily disable ArgoCD auto-sync (e.g. to test changes locally before pushing)?**

ArgoCD UI → open the app → **App Details** → **Summary** → **Disable Auto-Sync**.

---

**How to add a new encrypted variable to vault.yml?**
1. Run `ansible-vault encrypt_string --stdin-name 'encrypted_var_name'`
2. Enter your vault password when prompted, then paste the secret value and hit Ctrl-D.
3. Copy the output block and append it to `group_vars/all/vault.yml`.
Example output:
```yaml
# vault.yml
very_secret_token: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          184467440737095516153237343461383437646538623832656430666238336632660a33662343
          18446744073709551615a3366626236336466656138303135334590856739486757a3984738373
          ...
```

Place the file under `group_vars/all/` for all hosts, or `group_vars/<groupname>/` to scope it to a specific group.
4. Create an ansible vault password file with 600 permissions in home directory and add it to `ansible.cfg`:
```yaml
# vault_password
[defaults]
...
...
vault_password_file = ~/.vault_password
```

---
