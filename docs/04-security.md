# 🛡️ Home Server Security Hardening

## Overview

This document outlines the security hardening steps implemented on my Ubuntu home server. The goal was to secure remote administration, reduce the attack surface, and build a secure foundation for self-hosted applications.

---

# Technologies Used

- Ubuntu Server
- OpenSSH
- UFW (Uncomplicated Firewall)
- Fail2Ban
- Tailscale

---

# 1. SSH Key Authentication

## Generated SSH Key Pair

```bash
ssh-keygen -t ed25519 -f ~/.ssh/homeserver
```

Generated:

- `homeserver` (Private Key)
- `homeserver.pub` (Public Key)

---

## Installed Public Key

Copied the public key into:

```text
~/.ssh/authorized_keys
```

Verified successful authentication using:

- Local LAN IP
- Tailscale IP
- PuTTY
- Linux Terminal

---

# 2. SSH Hardening

Modified:

```text
/etc/ssh/sshd_config
```

Configured:

```text
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
PermitEmptyPasswords no

MaxAuthTries 3
LoginGraceTime 30

ClientAliveInterval 300
ClientAliveCountMax 2

X11Forwarding no
AllowAgentForwarding no
```

## Purpose

- Disable direct root login
- Disable password authentication
- Enforce SSH key authentication
- Reduce brute-force attacks
- Reduce unnecessary SSH features
- Minimize attack surface

---

# 3. UFW Firewall

## Default Policies

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```

## SSH Rule

```bash
sudo ufw allow 22/tcp comment 'ssh'
```

*(Replace with the custom SSH port after verifying the port migration.)*

## Tailscale Rule

```bash
sudo ufw allow in on tailscale0
```

This allows trusted traffic from authenticated devices on my Tailnet.

---

# 4. Fail2Ban

Installed and configured Fail2Ban to protect the SSH service against brute-force attacks.

Useful commands:

```bash
sudo fail2ban-client status
```

```bash
sudo fail2ban-client status sshd
```

---

# Challenge Encountered

## SSH Port Would Not Change

I changed the SSH port from:

```text
22
```

to

```text
2322
```

inside:

```text
/etc/ssh/sshd_config
```

However, after restarting SSH, the service continued listening on port 22.

Checking:

```bash
sudo ss -tlnp | grep ssh
```

returned:

```text
0.0.0.0:22
```

even though:

```bash
sudo sshd -T | grep port
```

returned:

```text
port 2322
```

---

# Root Cause

Ubuntu was using **systemd socket activation**.

The SSH service was being started by:

```text
ssh.socket
```

which was configured with:

```text
ListenStream=22
```

This meant the socket controlled the listening port instead of `sshd_config`.

---

# Resolution

Identified that the SSH daemon was being triggered by `ssh.socket` rather than directly reading the configured port.

This troubleshooting process reinforced the importance of understanding how Linux services interact instead of relying solely on configuration files.

---

# Lessons Learned

- SSH key authentication is significantly more secure than passwords.
- Always verify every SSH access method before disabling password authentication.
- UFW provides host-level protection by controlling inbound and outbound traffic.
- Fail2Ban helps mitigate brute-force attacks by automatically banning repeated failed login attempts.
- Tailscale provides secure private remote access without exposing SSH publicly.
- Modern Ubuntu versions may use **systemd socket activation**, which can affect how SSH listens on network ports.
- Understanding Linux services is just as important as knowing the commands.

---

# Security Controls Implemented

- ✅ SSH Key Authentication
- ✅ Disabled Password Authentication
- ✅ Disabled Root SSH Login
- ✅ UFW Firewall
- ✅ Fail2Ban
- ✅ Tailscale Firewall Rule
- ✅ SSH Hardening
- ✅ Reduced SSH Attack Surface

---