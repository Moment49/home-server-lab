#!/bin/bash

# Add Tailscale's GPG key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/resolute.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null

# Add the tailscale repository
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/resolute.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# Install Tailscale
sudo apt-get update && sudo apt-get install tailscale

echo "Tailscale successfully installed"

# Start Tailscale!
sudo tailscale up

