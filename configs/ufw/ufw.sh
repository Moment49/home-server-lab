#!/bin/bash

# UFW Firewall

## Default Policies

sudo ufw default deny incoming
sudo ufw default allow outgoing

## SSH Rule

sudo ufw allow {Custom_SSH_Port}/tcp  "(Replace with the custom SSH port after verifying the port migration.)"

## Tailscale Rule

sudo ufw allow in on tailscale0

sudo ufw enable

sudo ufw status verbose