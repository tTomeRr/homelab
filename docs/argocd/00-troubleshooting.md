# ArgoCD Troubleshooting

## Get Initial Admin Password

Run the ArgoCD playbook to retrieve the initial password:

```bash
ansible-playbook main.yml --tags argocd
```

The credentials will be printed in the last task output.

Default username: `admin`
