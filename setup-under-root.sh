#!/bin/bash

# For reference: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html.
set -vxeuo pipefail

# Clean-up a leftover file (owned by root) produced before us.
sudo rm -f /home/vagrant/.wget-hsts

# Install X11 for matplotlib, etc.
sudo apt-get update
sudo apt-get install -y xserver-xorg-core x11-utils x11-apps

sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
