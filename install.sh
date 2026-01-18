#!/bin/bash
# Simple VM Manager Installer
# Sponsor: Grandpa Academy
# Developer: MD HR

echo "Installing VM Manager v3.0..."
echo "Sponsor: Grandpa Academy"
echo "Developer: MD HR"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
  echo "Error: Do not run as root"
  exit 1
fi

# Install dependencies
echo "Installing dependencies..."
if command -v apt &> /dev/null; then
    sudo apt update
    sudo apt install -y qemu-system-x86 qemu-utils cloud-image-utils wget
elif command -v yum &> /dev/null; then
    sudo yum install -y qemu-kvm qemu-img cloud-utils wget
elif command -v dnf &> /dev/null; then
    sudo dnf install -y qemu-kvm qemu-img cloud-utils wget
else
    echo "Package manager not found. Please install manually:"
    echo "  qemu-system-x86_64, qemu-img, cloud-localds, wget"
fi

# Download the script
echo "Downloading VM Manager..."
curl -fsSL https://raw.githubusercontent.com/Granpa69-HR/test-vm/main/vps.sh -o vps.sh

# Make it executable
chmod +x vps.sh

echo ""
echo "✅ Installation complete!"
echo ""
echo "To run VM Manager:"
echo "  ./vps.sh"
echo ""
echo "Sponsor: Grandpa Academy"
echo "Developer: MD HR"
