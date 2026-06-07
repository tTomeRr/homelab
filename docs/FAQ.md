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
2. Enter your vault password if prompted (it will not ask for vault password if you run it in the ansible directory), then paste the secret value and hit Ctrl-D twice (Do not press enter!).
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
5. Validate the token is readable by executing:
```bash
 ansible -i inventory.ini all -m debug -a "var=very_secret_token"
```

---

**How to rotate secrets?**

**Cloudflare token** (`infrastructure/ansible/proxmox/`):
1. Cloudflare dashboard → Mangage Account →  **Account API Tokens** → find the token → **⋯** → **Roll**.
2. Re-encrypt:
```bash
ansible-vault encrypt_string --stdin-name 'cf_token'
```
3. Re-run the proxmox playbook: `ansible-playbook main.yaml`

**Discord webhook** (`infrastructure/ansible/k3s/`):
1. Discord → channel Settings → Integrations → Webhooks → delete old, create new, copy full URL.
2. Re-encrypt:
```bash
ansible-vault encrypt_string --stdin-name 'discord_webhook_token'
```
3. Re-run the k3s playbook: `ansible-playbook main.yaml`

**k3s cluster token** (`infrastructure/ansible/k3s/`):
1. Generate a new token and save it to Bitwarden:
```bash
openssl rand -base64 64 | tr -d '\n'
```
2. Re-encrypt:
```bash
ansible-vault encrypt_string --stdin-name 'k3s_token'
```
3. Rotate the token on the cluster (SSH to master):
```bash
sudo k3s token rotate --new-token "<new token value>"
```
4. Restart the agents on each worker node:
```bash
sudo systemctl restart k3s-agent
```
5. Re-run the k3s playbook: `ansible-playbook main.yaml`

---

**How to rotate the Ansible vault password?**

> `ansible-vault rekey` does not work for `encrypt_string` inline variables - each must be decrypted and re-encrypted manually.

1. Generate a new vault password and save it to Bitwarden:
```bash
openssl rand -base64 48 | tr -d '\n' > ~/.vault_password && chmod 600 ~/.vault_password
```
2. Re-encrypt all variables with the new password using the decoded secret values - follow the **"How to rotate secrets?"** guide above for each one.
3. Verify all variables decrypt correctly:
```bash
# From infrastructure/ansible/proxmox/
ansible -i inventory.ini all -m debug -a "var=cf_token"
# From infrastructure/ansible/k3s/
ansible -i inventory.ini all -m debug -a "var=discord_webhook_token"
ansible -i inventory.ini all -m debug -a "var=k3s_token"
```

---

**How to upgrade the k3s nodes?**

1. Go to the [k3s releases page](https://github.com/k3s-io/k3s/releases) and copy the release tag (e.g. `v1.33.4+k3s1`).
2. Update `k3s_version` in `infrastructure/ansible/k3s/inventory.ini` with the new tag.
3. Run the upgrade playbook from `infrastructure/ansible/k3s/`:
```bash
ansible-playbook k3s.orchestration.upgrade -i inventory.ini
```

---

**How to create a Bitnami sealed secret?**

1. Create a plain Kubernetes Secret manifest (do not apply it to the cluster):
```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: some-secret
  namespace: myapp
type: Opaque
stringData:
  SECRET_ENV: secret_var
```
2. Seal it with `kubeseal`:
```bash
kubeseal --controller-name sealed-secrets --controller-namespace kube-system \
  --format=yaml < secret.yaml > secret-sealed.yaml
```
> **Note**:  Make sure that you configure kubectl to use the namespace where you want your secret.
> e.g `kubectl config set-context --current --namespace homepage`

3. Apply the sealed secret to the cluster:
```bash
kubectl apply -f sealed-secrets.yaml
```
4. Verify the controller decrypted it into a regular Secret:
```bash
kubectl get sealedsecrets.bitnami.com -n myapp
```

> Never commit the unsealed file.`.
> Comment the sealed secret with  # gitleaks:allow to pass pre-commit test.

---

**How to upgrade the k3s-ansible galaxy role?**

1. Go to the [k3s-ansible repo](https://github.com/k3s-io/k3s-ansible) and copy the full commit SHA of the latest `main` commit.
2. Update the `version:` field in `infrastructure/ansible/k3s/requirements.yml` with the new SHA.
3. Re-install the collection:
```bash
ansible-galaxy collection install -r requirements.yml --force
```

---

**How to upgrade ArgoCD?**

1. Check the [upgrading docs](https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/overview/) for breaking changes
2. Update `argocd_version` in `roles/argocd/defaults/main.yml`.
3. Run the playbook from `infrastructure/ansible/k3s/`:
```bash
ansible-playbook main.yaml --tags argocd
```

> ArgoCD recommends upgrading one minor version at a time (e.g. 3.2 → 3.3 → 3.4)

---
