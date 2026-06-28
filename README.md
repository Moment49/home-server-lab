# 🖥️ Home Server Lab

A documented journey of building a personal home server
using an HP EliteBook for learning backend engineering,
DevOps, and cybersecurity.

## What This Server Does
- 📁 Personal file storage (Nextcloud)
- 🎬 Media streaming (Jellyfin)
- 🔐 Cybersecurity home lab (DVWA, Metasploitable)
- 📊 Server monitoring (Netdata/Grafana)
- 🌐 Hosts Django web applications

## Stack
- OS: Ubuntu Server 24.04 LTS
- Web Server: Nginx + Gunicorn
- Database: PostgreSQL
- Containers: Docker + Docker Compose
- Tunnel: Cloudflare Tunnel
- Remote Access: Tailscale
- Domain: yourdomain.com.ng

## Progress
- ✅ Ubuntu Server installation
- [ ] Network and static IP setup
- [ ] SSH hardening and security
- [ ] Cloudflare Tunnel + domain
- [ ] Docker installation
- [ ] Django Application deployment
- [ ] Nextcloud file storage
- [ ] Jellyfin media server
- [ ] Cybersecurity lab setup
- [ ] Monitoring dashboard

## Documentation
All steps documented in /docs folder.

## Why we Built This
Learning by doing | — real infrastructure, deployments, 
building practical DevOps and security skills.

## 🔒 Security Notice

All IPs, credentials, and personal config values 
in this documentation are placeholders.

Replace the following with your own values:
| Placeholder | What It Represents |
|---|---|
| `192.168.1.100` | Your server's local IP |
| `yourdomain.com` | Your actual domain |
| `YOUR_WIFI_SSID` | Your WiFi network name |
| `youruser` | Your Ubuntu username |
| `YOUR_API_KEY` | Any API keys or tokens |

Never commit real credentials to a public repository.
Use `.env` files for secrets and add them to `.gitignore`.