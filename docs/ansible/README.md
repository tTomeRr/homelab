## Troubleshooting

### Host key verification failed

If Ansible fails with `Host key verification failed`, the target host is not in your `~/.ssh/known_hosts`. SSH into the host once manually to add it, or run:

```bash
ssh-keyscan -H <hostname> >> ~/.ssh/known_hosts
```
