#!/bin/bash

# Proxmox Post-Install Setup
# Run script as root on Proxmox host

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}Error: This script must be run as root${NC}"
  exit 1
fi

if ! command -v sudo &>/dev/null; then
  echo -e "${YELLOW}Installing sudo...${NC}"
  apt-get update -qq
  apt-get install -y sudo
  echo -e "${GREEN}sudo installed${NC}"
  echo ""
fi

echo "======================================================="
echo "  Proxmox SSH Security Configuration"
echo "======================================================="
echo ""

# Prompt for username
while true; do
  read -pr "Enter username to create: " USERNAME

  if id "$USERNAME" &>/dev/null; then
    echo -e "${RED}User $USERNAME already exists${NC}"
    continue
  fi

  break
done

# Prompt for public key
echo ""
echo "Paste your SSH public key (starts with ssh-ed25519 or ssh-rsa):"
read -pr "> " PUBKEY

if [[ ! "$PUBKEY" =~ ^(ssh-rsa|ssh-ed25519|ecdsa-sha2-nistp) ]]; then
  echo -e "${RED}Error: Invalid SSH public key format${NC}"
  exit 1
fi

# Generate random 12-character sudo password
SUDO_PASSWORD=$(openssl rand -base64 12 | tr -d '/+=' | head -c 12)

echo ""
echo -e "${YELLOW}Creating user and configuring SSH...${NC}"

# Configure User
if ! useradd -m -s /bin/bash "$USERNAME" 2>&1; then
  echo -e "${RED}Error: Failed to create user${NC}"
  exit 1
fi

if ! echo "$USERNAME:$SUDO_PASSWORD" | chpasswd 2>&1; then
  echo -e "${RED}Error: Failed to set password${NC}"
  exit 1
fi

if ! usermod -aG sudo "$USERNAME" 2>&1; then
  echo -e "${RED}Error: Failed to add user to sudo group${NC}"
  exit 1
fi

# Setup SSH
mkdir -p "/home/$USERNAME/.ssh"
echo "$PUBKEY" >"/home/$USERNAME/.ssh/authorized_keys"
chmod 700 "/home/$USERNAME/.ssh"
chmod 600 "/home/$USERNAME/.ssh/authorized_keys"
chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"

cp "/etc/ssh/sshd_config" "/etc/ssh/sshd_config.backup.$(date +%Y%m%d_%H%M%S)"

sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

if ! grep -q "^AllowUsers" /etc/ssh/sshd_config; then
  echo "AllowUsers $USERNAME" >>/etc/ssh/sshd_config
else
  sed -i "s/^AllowUsers.*/AllowUsers $USERNAME/" /etc/ssh/sshd_config
fi

# Validate SSH config
if ! sshd -t; then
  echo -e "${RED}Error: SSH configuration is invalid. Restoring backup.${NC}"
  cp /etc/ssh/sshd_config.backup.* /etc/ssh/sshd_config
  exit 1
fi

# Summary
echo ""
echo "======================================================="
echo "  CONFIGURATION COMPLETE"
echo "======================================================="
echo ""
echo -e "${GREEN}User created: $USERNAME${NC}"
echo -e "${GREEN}SSH access: KEY-BASED ONLY${NC}"
echo -e "${GREEN}Root SSH login: DISABLED${NC}"
echo ""
echo "-------------------------------------------------------"
echo "  SAVE TO BITWARDEN NOW"
echo "-------------------------------------------------------"
echo ""
echo "Username: $USERNAME"
echo "Sudo Password: $SUDO_PASSWORD"
echo ""
echo "-------------------------------------------------------"
echo "  TESTING INSTRUCTIONS"
echo "-------------------------------------------------------"
echo ""
echo "1. Open a NEW terminal (keep this one open)"
echo ""
echo "2. Test SSH connection:"
echo "   ssh -i ~/.ssh/proxmox $USERNAME@$(hostname -I | awk '{print $1}')"
echo ""
echo "3. Test sudo access:"
echo "   sudo -i"
echo "   (use sudo password above)"
echo ""
echo "4. If successful, restart SSH:"
echo "   sudo systemctl restart sshd"
echo ""
echo "5. If test fails, fix issues before closing this session"
echo ""
echo "-------------------------------------------------------"
echo "  IMPORTANT"
echo "-------------------------------------------------------"
echo ""
echo "- DO NOT close this terminal until SSH is tested"
echo "- Save credentials to Bitwarden NOW"
echo "- SSH config backup: /etc/ssh/sshd_config.backup.*"
echo ""
echo "======================================================="
