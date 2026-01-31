# qBittorrent Troubleshooting

## Get Default Password

On first run, qBittorrent generates a random password. To retrieve it:

```bash
kubectl logs -n qbittorrent deployment/qbittorrent-deployment | grep -i password
```

Default username: `admin`
