we follow this guide: https://adguard-dns.io/kb/adguard-home/getting-started/
1. After installation go to the proxmox ip in port 3000 e.g 192.168.100.100:3000
2. In the installation screen, Because of port conflict with Caddy (both want port 80) - change adguard port to listen to port 3000.
3. choose username and passowrd
4. Then finish the installation, and configure the dns server to be the adguard address. in my xiomi router it was:
Commonly used settings -> internet settings -> Manually configure DNS -> add proxmox ip -> save chagnes
