# dev.nix - Development environment for VM Manager
# Sponsor: Grandpa Academy
# Developer: MD HR

{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib
}:

let
  # Helper function to check if running in NixOS
  isNixOS = pkgs.stdenv.isLinux && builtins.pathExists /etc/NIXOS;

  # Custom package set for VM management
  vmManagerPackages = with pkgs; [
    # Core virtualization packages
    qemu_kvm
    qemu_full
    qemu-utils
    qemu-guest-agent
    qemu_xen
    qemu_test
    swtpm
    libvirt
    virt-manager
    virt-viewer

    # Cloud image utilities
    cloud-utils
    cloud-init
    cdrkit
    genisoimage
    mtools

    # System utilities
    wget
    curl
    git
    unzip
    p7zip
    gnutar
    gzip
    pigz
    pbzip2
    lz4
    zstd

    # Networking tools
    openssh
    sshfs
    nmap
    netcat-openbsd
    iperf3
    iputils
    net-tools
    bridge-utils
    dnsutils
    wget2

    # Monitoring and performance tools
    htop
    btop
    iotop
    iftop
    nethogs
    glances
    sysstat
    lm_sensors
    smartmontools
    dmidecode

    # Disk and storage tools
    parted
    gparted
    dosfstools
    ntfs3g
    exfat
    f2fs-tools
    xfsprogs
    btrfs-progs
    lvm2
    mdadm

    # Development tools
    gcc
    gdb
    valgrind
    strace
    ltrace
    perf-tools
    binutils
    file
    which
    pv
    progress
    moreutils

    # Text editors and viewers
    vim
    nano
    micro
    less
    jq
    yq
    bat
    exa
    fzf
    ripgrep
    fd
    sd
    hexyl

    # Python tools (for potential extensions)
    python3
    python3Packages.pip
    python3Packages.virtualenv

    # Shell utilities
    bash
    zsh
    fish
    tmux
    screen
    direnv
    shellcheck
    shfmt

    # Security tools
    gnupg
    openssl
    age
    sops
    sshpass
    expect
    pwgen

    # GUI tools (optional, for VM display)
    x11vnc
    tigervnc
    tightvnc
    spice-protocol
    spice-gtk
    virt-viewer

    # Container tools (for comparison/testing)
    docker
    podman
    buildah
    skopeo
    runc
    crun
  ];

  # Service configuration for NixOS
  nixosServiceConfig = {
    # Enable KVM kernel module
    boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

    # Add user to required groups
    users.users.${builtins.getEnv "USER"} = {
      extraGroups = [ "kvm" "libvirtd" "qemu-libvirtd" "docker" "podman" ];
    };

    # Enable virtualization services
    virtualisation = {
      # QEMU/KVM
      qemu = {
        enable = true;
        runAsRoot = false;
        package = pkgs.qemu_kvm;
      };

      # Libvirt
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
        };
      };

      # Docker
      docker = {
        enable = true;
        autoPrune.enable = true;
        daemon.settings = {
          experimental = true;
        };
      };

      # Podman
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      # LXC/LXD
      lxd.enable = true;
    };

    # Networking for VMs
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 8080 8443 3389 5900 5901 ];
      allowedUDPPorts = [ 53 67 68 69 123 ];
      checkReversePath = false;
    };

    # Enable nested virtualization if supported
    boot.extraModprobeConfig = ''
      options kvm-intel nested=1
      options kvm-amd nested=1
    '';

    # Performance tuning
    boot.kernel.sysctl = {
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 50;
      "net.core.somaxconn" = 65535;
      "net.core.netdev_max_backlog" = 5000;
      "net.ipv4.tcp_max_syn_backlog" = 65535;
      "net.ipv4.ip_local_port_range" = "1024 65535";
    };
  };

  # Development environment setup script
  setupScript = pkgs.writeShellScriptBin "setup-vm-manager" ''
    #!/bin/bash
    set -euo pipefail

    echo "================================================"
    echo "   VM Manager Development Environment Setup"
    echo "   Sponsor: Grandpa Academy"
    echo "   Developer: MD HR"
    echo "================================================"
    echo ""

    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
      echo "❌ Please do not run this script as root"
      exit 1
    fi

    # Create necessary directories
    echo "📁 Creating directories..."
    mkdir -p ~/vms
    mkdir -p ~/.config/vm-manager
    mkdir -p ~/.local/share/vm-manager

    # Set permissions
    echo "🔐 Setting permissions..."
    chmod 755 ~/vms
    chmod 700 ~/.config/vm-manager

    # Check KVM support
    echo "🔍 Checking KVM support..."
    if [[ -c /dev/kvm ]]; then
      echo "✅ KVM device found at /dev/kvm"
      
      # Check if user is in kvm group
      if groups | grep -q kvm; then
        echo "✅ User is in 'kvm' group"
      else
        echo "⚠️  User is NOT in 'kvm' group"
        echo "   To add yourself: sudo usermod -aG kvm $USER"
      fi
    else
      echo "❌ KVM device not found"
      echo "   Please enable virtualization in BIOS/UEFI"
    fi

    # Check CPU virtualization support
    echo "🔍 Checking CPU virtualization extensions..."
    if grep -q -E 'vmx|svm' /proc/cpuinfo; then
      echo "✅ CPU virtualization extensions detected"
    else
      echo "❌ CPU virtualization extensions NOT detected"
    fi

    # Create example configuration
    echo "📝 Creating example configuration..."
    cat > ~/.config/vm-manager/config.env << 'EOF'
# VM Manager Configuration
# Sponsor: Grandpa Academy
# Developer: MD HR

# Default VM directory
VM_BASE_DIR="$HOME/vms"

# Default resources
DEFAULT_MEMORY="2048"
DEFAULT_CPUS="2"
DEFAULT_DISK="20G"
DEFAULT_SSH_PORT="2222"

# Network settings
BRIDGE_INTERFACE="virbr0"
NETWORK_CIDR="192.168.122.0/24"

# Performance settings
QEMU_OPTS="-enable-kvm -cpu host -smp sockets=1,cores=2,threads=2"
DISK_CACHE="writeback"
IO_THREADS="yes"

# Cloud-init settings
CLOUD_USER="ubuntu"
CLOUD_PASSWORD="ubuntu"
CLOUD_SSH_KEY="$HOME/.ssh/id_rsa.pub"

# Logging
LOG_LEVEL="INFO"
LOG_FILE="$HOME/.local/share/vm-manager/vm-manager.log"
EOF

    # Create SSH key if not exists
    echo "🔑 Setting up SSH keys..."
    if [[ ! -f ~/.ssh/id_rsa ]]; then
      mkdir -p ~/.ssh
      ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
      echo "✅ Generated new SSH key"
    else
      echo "✅ SSH key already exists"
    fi

    # Create helper scripts
    echo "📜 Creating helper scripts..."
    
    # Quick start script
    cat > ~/vms/quick-start.sh << 'EOF'
#!/bin/bash
# Quick VM starter script
# Usage: ./quick-start.sh <vm-name>

VM_NAME="''${1:-}"
VM_DIR="$HOME/vms"

if [[ -z "$VM_NAME" ]]; then
    echo "Usage: $0 <vm-name>"
    exit 1
fi

CONFIG_FILE="$VM_DIR/$VM_NAME.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "VM configuration not found: $CONFIG_FILE"
    exit 1
fi

# Load configuration
source "$CONFIG_FILE"

# Start VM
echo "Starting VM: $VM_NAME"
echo "SSH: ssh -p $SSH_PORT $USERNAME@localhost"
echo "Password: $PASSWORD"

qemu-system-x86_64 \
  -enable-kvm \
  -m "$MEMORY" \
  -smp "$CPUS" \
  -cpu host \
  -drive "file=$IMG_FILE,format=qcow2,if=virtio" \
  -drive "file=$SEED_FILE,format=raw,if=virtio" \
  -boot order=c \
  -device virtio-net-pci,netdev=n0 \
  -netdev "user,id=n0,hostfwd=tcp::$SSH_PORT-:22" \
  -nographic
EOF

    chmod +x ~/vms/quick-start.sh

    # Backup script
    cat > ~/vms/backup-vm.sh << 'EOF'
#!/bin/bash
# VM Backup Script
# Usage: ./backup-vm.sh <vm-name>

VM_NAME="''${1:-}"
VM_DIR="$HOME/vms"
BACKUP_DIR="$HOME/vm-backups"
DATE=$(date +%Y%m%d_%H%M%S)

if [[ -z "$VM_NAME" ]]; then
    echo "Usage: $0 <vm-name>"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# Stop VM if running
if pgrep -f "qemu-system-x86_64.*$VM_NAME" >/dev/null; then
    echo "Stopping VM: $VM_NAME"
    pkill -f "qemu-system-x86_64.*$VM_NAME"
    sleep 5
fi

# Backup files
echo "Backing up VM: $VM_NAME"
BACKUP_FILE="$BACKUP_DIR/${VM_NAME}_${DATE}.tar.gz"

tar -czf "$BACKUP_FILE" \
  -C "$VM_DIR" \
  "$VM_NAME.conf" \
  "$VM_NAME.img" \
  "$VM_NAME-seed.iso" 2>/dev/null || true

echo "Backup created: $BACKUP_FILE"
echo "Size: $(du -h "$BACKUP_FILE" | cut -f1)"
EOF

    chmod +x ~/vms/backup-vm.sh

    # Create README
    cat > ~/vms/README.md << 'EOF'
# VM Manager Development Environment

## Overview
This directory contains Virtual Machines managed by the VM Manager tool.

## Directory Structure
