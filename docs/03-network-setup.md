# 03 — Network Setup

## What This Covers

- Cloning the repo and running the setup script on the server
- Setting a static IP address on the HP EliteBook server using Netplan
- Understanding subnetting and how it applies to this setup
- Configuring file permissions on sensitive config files
- Installing Tailscale for private remote access

---

## Step 1 — Clone the Repo and Run Setup Script

After the Ubuntu Server installation was complete and SSH was working, the first thing done was cloning the project repo directly onto the server and running the initialisation script to set up the base environment.

```bash
# SSH into the server from the new system
ssh youruser@YOUR_SERVER_IP

# Clone the repo
git clone https://github.com/yourusername/home-server-lab
cd home-server-lab

# Make the setup script executable
chmod +x scripts/setup.sh

# Run the setup script
./scripts/setup.sh
```

This installs Git, Docker, Docker Compose, UFW, Fail2ban and Tailscale in one go — no manual package installation needed.

---

## Step 2 — Setting a Static IP Address

### Why a Static IP Is Needed

By default the router assigns IPs dynamically via DHCP — meaning the server could get a different IP address every time it reboots. This breaks SSH connections and makes the server unreliable to reach.

Setting a static IP means the server is always at the same address on the local network regardless of reboots or router changes.

### Understanding Subnetting First

Before configuring the static IP, subnetting was revisited to understand what the values in the config actually mean:

```
YOUR_NETWORK_SUBNET

Example breakdown:
192.168.1.100/24

192.168.1.100  →  the IP address of the server
/24            →  subnet mask (255.255.255.0)
               →  means 254 usable host addresses
               →  range: .1 to .254 on this network

Default gateway (router): YOUR_ROUTER_IP
This is the single exit point for all traffic
leaving the local network to the internet
```

Understanding this made it clear what each field in the Netplan config actually represents — not just copying values blindly.

---

### Netplan — What It Is

Netplan is the network configuration tool used in Ubuntu Server. It reads YAML config files and applies them to the system's network interfaces.

Netplan has two backend renderers:

| Renderer | Best for | Why |
|---|---|---|
| `networkd` | Servers (headless) | Lightweight, minimal resources, no GUI needed |
| `NetworkManager` | Desktops and laptops | Advanced features, GUI support, higher resource use |

**`networkd` was chosen** because this is a headless Ubuntu Server — no desktop, no GUI. `networkd` is leaner and more appropriate for server environments.

---

### Finding the WiFi Interface Name

Before writing the config, the correct WiFi interface name on the EliteBook was confirmed:

```bash
ip link show
# Look for the wireless interface — usually wlan0 or wlp2s0
# On this EliteBook it was: wlp2s0
```

---

### Writing the Netplan Config

Instead of modifying the default starter config file provided by Ubuntu, a new YAML file was written from scratch. This was a deliberate learning decision — writing it manually forces understanding of every field rather than editing an existing template.

```bash
# Navigate to netplan directory
cd /etc/netplan/

# List existing config files
ls -la
# Two files exist — netplan applies them in lexicographic order
# A file named 99-custom.yaml will override the default one

# Create a new config file
sudo nano 99-custom.yaml
```

```yaml
network:
  version: 2
  renderer: networkd
  wifis:
    wlp2s0:
      dhcp4: no
      dhcp6: no
      addresses: [YOUR_SERVER_IP/24]
      nameservers:
        addresses: [YOUR_ISP_DNS, 8.8.8.8]
      access-points:
        YOUR_ROUTER_SSID:
          password: YOUR_WIFI_PASSWORD
      routes:
        - to: default
          via: YOUR_ROUTER_IP
```

**What each field means:**

| Field | Value | Purpose |
|---|---|---|
| `renderer` | `networkd` | Lightweight backend for servers |
| `wlp2s0` | WiFi interface name | The wireless interface on this EliteBook |
| `dhcp4: no` | Disabled | We are setting IP manually, not from router |
| `dhcp6: no` | Disabled | No IPv6 needed |
| `addresses` | `YOUR_SERVER_IP/24` | Static IP with subnet mask |
| `nameservers` | ISP DNS + Google DNS | DNS resolution for domain names |
| `access-points` | Router SSID + password | WiFi network to connect to |
| `routes: via` | `YOUR_ROUTER_IP` | Default gateway — all traffic exits here |

> ⚠️ **Security note:** The Netplan config contains sensitive information in plaintext — WiFi SSID name and password. This is why strict file permissions were applied immediately after writing the config.

---

### Securing the Config File

During `sudo netplan try`, a warning appeared about file permissions — the config was readable by multiple users which is a security risk given it contains the WiFi password in plaintext.

This was fixed by locking the file down to root only:

```bash
# Give root ownership of the file
sudo chown root:root /etc/netplan/99-custom.yaml

# Set permissions — only root can read and write
# No access for any other user
sudo chmod 600 /etc/netplan/99-custom.yaml

# Verify permissions
ls -la /etc/netplan/
# Should show: -rw------- root root 99-custom.yaml
```

```
Permission breakdown:
600 = rw-------
r w -   r - -   - - -
owner  group  others
root   none   none

Only root can read or write the file.
All other users have zero access.
```

---

### Testing and Applying the Config

```bash
# Test the config before applying — safe to try
# Reverts automatically after 120 seconds if not confirmed
sudo netplan try

# If no errors — press Enter to confirm and keep changes
# Config is now applied

# Apply permanently
sudo netplan apply

# Verify the static IP is set
ip addr show wlp2s0
```

**Lexicographic override note:**
Two config files exist in `/etc/netplan/`. Netplan applies them in alphabetical order — the file named `99-custom.yaml` is applied last and overrides the default starter config. This was confirmed by reading the Netplan documentation before writing the config.

---

### Verifying After Reboot

To fully confirm the static IP was working, the server was remotely shut down and powered back on:

```bash
# Shut down the server remotely from new system
ssh youruser@YOUR_SERVER_IP "sudo shutdown now"

# Power the server back on physically
# Wait 60 seconds for boot

# SSH back in using the static IP
ssh youruser@YOUR_SERVER_IP

# It worked — server came back at the same IP
```

✅ Static IP confirmed working after full reboot.

---

## Problems Hit

### Problem 1 — Root Privilege Required to Edit Netplan Config

**What happened:**
Tried to edit the Netplan config file without sudo and was denied permission — the file is owned by root.

**Fix:**
Used sudo for all Netplan operations. Created a strong root password first:
```bash
sudo passwd root
```

---

### Problem 2 — Netplan Permission Warning

**What happened:**
Running `sudo netplan try` showed a warning:
```
WARNING: /etc/netplan/99-custom.yaml has too wide permissions
```
The config file was readable by other users — a security risk since it contains the WiFi password in plaintext.

**Fix:**
```bash
sudo chmod 600 /etc/netplan/99-custom.yaml
sudo chown root:root /etc/netplan/99-custom.yaml
```

---

### Problem 3 — Two Config Files Conflicting

**What happened:**
Ubuntu ships with a default Netplan config file. Having two files raised questions about which one would apply.

**Fix:**
Read the Netplan documentation and learned that config files are applied in **lexicographic (alphabetical) order** — the last file wins. Naming the custom file `99-custom.yaml` ensures it is always applied last and overrides the default.

---

## Result

```
✅ Repo cloned and setup script executed on server
✅ Static IP set and confirmed working after reboot
✅ Netplan config written from scratch (not from template)
✅ Config file secured — root only permissions
✅ Tailscale installed and server accessible remotely
✅ SSH working from new system via local IP
✅ SSH working from outside via Tailscale IP
```

---
## Screenshots
![alt text](screenshots/image.png)

## Next Step

→ [04 — Security Setup — UFW, Fail2ban and SSH Hardening](04-security.md)
