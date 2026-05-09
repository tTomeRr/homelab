## FAQ

**How to add a new app to the cluster?**

1. Create `apps/myapp/` with your manifests inside.
2. Create `apps/myapp.yaml` — copy an existing one (e.g. `apps/homepage.yaml`) and update `name`, `path`, and `namespace`.
3. `kubectl apply -f apps/myapp.yaml`

---

**How to temporarily disable ArgoCD auto-sync (e.g. to test changes locally before pushing)?**

ArgoCD UI → open the app → **App Details** → **Summary** → **Disable Auto-Sync**.

---
