#!/bin/bash
set -euo pipefail

# =============================
# Enhanced Multi-VM Manager
# =============================

# Function to display main header
display_header() {
    clear
    echo ""
    echo "================================================================================"
    echo "                     VIRTUAL MACHINE MANAGER v3.0"
    echo "================================================================================"
    echo ""
    echo "    ████████╗██╗    ██╗    ███╗   ███╗ █████╗ ███╗   ██╗ █████╗  ██████╗ ███████╗"
    echo "    ╚══██╔══╝██║    ██║    ████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝ ██╔════╝"
    echo "       ██║   ██║ █╗ ██║    ██╔████╔██║███████║██╔██╗ ██║███████║██║  ███╗█████╗  "
    echo "       ██║   ██║███╗██║    ██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══██║██║   ██║██╔══╝  "
    echo "       ██║   ╚███╔███╔╝    ██║ ╚═╝ ██║██║  ██║██║ ╚████║██║  ██║╚██████╔╝███████╗"
    echo "       ╚═╝    ╚══╝╚══╝     ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
    echo ""
    echo "================================================================================"
    echo " Sponsor: Grandpa Academy   |   Developer: MD HR   |   Version: 3.0"
    echo "================================================================================"
    echo ""
}

# Function to display OS selection menu
display_os_menu() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                    SELECT OPERATING SYSTEM                       ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    
    local i=1
    for os in "${!OS_OPTIONS[@]}"; do
        printf "║   %2d. %-30s %-10s ║\n" "$i" "$os" "($(echo ${OS_OPTIONS[$os]} | cut -d'|' -f1))"
        ((i++))
    done
    
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Function to display OS creation banner
display_os_creation_banner() {
    local os_type=$1
    local os_name=$2
    
    echo ""
    echo "================================================================================"
    case "$os_type" in
        "ubuntu")
            echo "CREATING: UBUNTU VIRTUAL MACHINE"
            echo "Version: $os_name"
            echo "Icon: 🐧 Ubuntu Linux"
            ;;
        "debian")
            echo "CREATING: DEBIAN VIRTUAL MACHINE"
            echo "Version: $os_name"
            echo "Icon: 🦊 Debian GNU/Linux"
            ;;
        "fedora")
            echo "CREATING: FEDORA VIRTUAL MACHINE"
            echo "Version: $os_name"
            echo "Icon: ∞ Fedora Linux"
            ;;
        "centos")
            echo "CREATING: CENTOS VIRTUAL MACHINE"
            echo "Version: $os_name"
            echo "Icon: 🎩 CentOS Stream"
            ;;
        "almalinux")
            echo "CREATING: ALMALINUX VIRTUAL MACHINE"
            echo "Version: $os_name"
            echo "Icon: 🌳 AlmaLinux"
            ;;
        "rockylinux")
            echo "CREATING: ROCKY LINUX VIRTUAL MACHINE"
            echo "Version: $os_name"
            echo "Icon: 🏔️ Rocky Linux"
            ;;
        *)
            echo "CREATING: CLOUD VIRTUAL MACHINE"
            echo "Type: $os_type"
            echo "Version: $os_name"
            ;;
    esac
    echo "================================================================================"
    echo ""
}

# Function to display VM creation progress
display_vm_progress() {
    local step=$1
    local vm_name=$2
    
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                VM CREATION PROGRESS                              ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    echo "║   VM Name: $vm_name"
    echo "║                                                                  ║"
    
    case $step in
        1) echo "║   ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        2) echo "║   ████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        3) echo "║   ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        4) echo "║   ████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        5) echo "║   ████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        6) echo "║   ████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        7) echo "║   ████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        8) echo "║   ████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        9) echo "║   ████████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░  ║";;
        10) echo "║   ████████████████████████████████████████░░░░░░░░░░░░░░░░░░░░  ║";;
        11) echo "║   ████████████████████████████████████████████░░░░░░░░░░░░░░░░  ║";;
        12) echo "║   ████████████████████████████████████████████████░░░░░░░░░░░░  ║";;
        13) echo "║   ████████████████████████████████████████████████████░░░░░░░░  ║";;
        14) echo "║   ████████████████████████████████████████████████████████░░░░  ║";;
        15) echo "║   ████████████████████████████████████████████████████████████  ║";;
    esac
    
    echo "║                                                                  ║"
    echo "║   Step $step/15: $(get_step_description $step)                      "
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
}

get_step_description() {
    local step=$1
    case $step in
        1) echo "Validating inputs";;
        2) echo "Creating VM directory";;
        3) echo "Downloading OS image";;
        4) echo "Setting up disk storage";;
        5) echo "Creating user configuration";;
        6) echo "Generating cloud-init data";;
        7) echo "Creating seed image";;
        8) echo "Configuring network";;
        9) echo "Setting up SSH access";;
        10) echo "Applying security settings";;
        11) echo "Saving configuration";;
        12) echo "Finalizing setup";;
        13) echo "Optimizing performance";;
        14) echo "Verifying installation";;
        15) echo "VM ready to start";;
    esac
}

# Function to display colored output
print_status() {
    local type=$1
    local message=$2
    
    case $type in
        "INFO") echo -e "🔹 \033[1;34m[INFO]\033[0m $message" ;;
        "WARN") echo -e "⚠️  \033[1;33m[WARN]\033[0m $message" ;;
        "ERROR") echo -e "❌ \033[1;31m[ERROR]\033[0m $message" ;;
        "SUCCESS") echo -e "✅ \033[1;32m[SUCCESS]\033[0m $message" ;;
        "INPUT") echo -e "🎯 \033[1;36m[INPUT]\033[0m $message" ;;
        "VM") echo -e "🖥️  \033[1;93m[VM]\033[0m $message" ;;
        "START") echo -e "🚀 \033[1;92m[START]\033[0m $message" ;;
        "STOP") echo -e "🛑 \033[1;91m[STOP]\033[0m $message" ;;
        *) echo "📌 $message" ;;
    esac
}

# Function to display VM list
display_vm_list() {
    local vms=($(get_vm_list))
    local vm_count=${#vms[@]}
    
    if [ $vm_count -gt 0 ]; then
        echo ""
        echo "╔══════════════════════════════════════════════════════════════════╗"
        echo "║                   AVAILABLE VIRTUAL MACHINES                     ║"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║                                                                  ║"
        echo "║   No.  VM Name            Status      SSH Port    Memory   CPU  ║"
        echo "║   ─────────────────────────────────────────────────────────────  ║"
        
        for i in "${!vms[@]}"; do
            local vm_name="${vms[$i]}"
            local config_file="$VM_DIR/$vm_name.conf"
            
            if [[ -f "$config_file" ]]; then
                # Load basic info without sourcing the entire config
                local ssh_port=$(grep '^SSH_PORT=' "$config_file" | cut -d'=' -f2 | tr -d '"')
                local memory=$(grep '^MEMORY=' "$config_file" | cut -d'=' -f2 | tr -d '"')
                local cpus=$(grep '^CPUS=' "$config_file" | cut -d'=' -f2 | tr -d '"')
                
                # Check if VM is running
                local status="🟢 Running"
                if ! pgrep -f "qemu-system-x86_64.*$vm_name" >/dev/null; then
                    status="🔴 Stopped"
                fi
                
                printf "║   %2d.  %-15s  %-10s  %-8s  %-6s  %-4s ║\n" \
                    $((i+1)) "$vm_name" "$status" "$ssh_port" "${memory}MB" "$cpus"
            fi
        done
        
        echo "║                                                                  ║"
        echo "╚══════════════════════════════════════════════════════════════════╝"
        echo ""
    else
        echo ""
        echo "========================================"
        echo "    No Virtual Machines Found"
        echo "========================================"
        echo ""
    fi
}

# Function to display VM details
display_vm_details() {
    local vm_name=$1
    
    if load_vm_config "$vm_name"; then
        echo ""
        echo "╔══════════════════════════════════════════════════════════════════╗"
        echo "║                   VM DETAILS: $vm_name"
        echo "╠══════════════════════════════════════════════════════════════════╣"
        echo "║                                                                  ║"
        echo "║   Basic Information:                                             ║"
        echo "║   • OS Type:      $OS_TYPE                                        "
        echo "║   • Hostname:     $HOSTNAME                                       "
        echo "║   • Created:      $CREATED                                        "
        echo "║                                                                  ║"
        echo "║   Access Details:                                                ║"
        echo "║   • Username:     $USERNAME                                       "
        echo "║   • Password:     ******                                         "
        echo "║   • SSH Port:     $SSH_PORT                                       "
        echo "║   • SSH Command:  ssh -p $SSH_PORT $USERNAME@localhost            "
        echo "║                                                                  ║"
        echo "║   Resource Allocation:                                           ║"
        echo "║   • Memory:       $MEMORY MB                                      "
        echo "║   • CPU Cores:    $CPUS                                           "
        echo "║   • Disk Size:    $DISK_SIZE                                      "
        echo "║                                                                  ║"
        echo "║   Configuration:                                                 ║"
        echo "║   • GUI Mode:     $GUI_MODE                                       "
        echo "║   • Port Forwards: ${PORT_FORWARDS:-None}                        "
        echo "║                                                                  ║"
        echo "║   Files:                                                         ║"
        echo "║   • Image:        $(basename "$IMG_FILE")                        "
        echo "║   • Config:       $vm_name.conf                                  "
        echo "║                                                                  ║"
        echo "╚══════════════════════════════════════════════════════════════════╝"
        echo ""
    fi
}

# Function to display main menu
display_main_menu() {
    local vms=($(get_vm_list))
    local vm_count=${#vms[@]}
    
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                      MAIN MENU                                   ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    echo "║   1. 🆕 Create New Virtual Machine                               ║"
    
    if [ $vm_count -gt 0 ]; then
        echo "║   2. 🚀 Start Virtual Machine                                    ║"
        echo "║   3. 🛑 Stop Virtual Machine                                     ║"
        echo "║   4. 📊 View VM Information                                     ║"
        echo "║   5. ⚙️  Edit VM Configuration                                   ║"
        echo "║   6. 📈 Monitor VM Performance                                  ║"
        echo "║   7. 💾 Resize VM Disk                                          ║"
        echo "║   8. 🗑️  Delete Virtual Machine                                  ║"
    fi
    
    echo "║   9. 🔄 Check System Requirements                                 ║"
    echo "║   0. 🚪 Exit                                                        ║"
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Function to display system check
display_system_check() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                   SYSTEM REQUIREMENTS CHECK                      ║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║                                                                  ║"
    
    # Check KVM support
    if lsmod | grep -q kvm; then
        echo "║   ✅ KVM Virtualization: Enabled                                ║"
    else
        echo "║   ❌ KVM Virtualization: Not enabled                            ║"
    fi
    
    # Check disk space
    local free_space=$(df -h "$VM_DIR" | tail -1 | awk '{print $4}')
    echo "║   📦 Available Disk Space: $free_space                            ║"
    
    # Check memory
    local total_mem=$(free -h | grep Mem | awk '{print $2}')
    echo "║   🧠 Total Memory: $total_mem                                      ║"
    
    # Check CPU
    local cpu_cores=$(nproc)
    echo "║   ⚡ CPU Cores: $cpu_cores                                         ║"
    
    echo "║                                                                  ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo ""
}

# Function to display goodbye message
display_goodbye() {
    echo ""
    echo "================================================================================"
    echo "                         THANK YOU FOR USING VM MANAGER"
    echo "================================================================================"
    echo ""
    echo "    Sponsor: Grandpa Academy"
    echo "    Developer: MD HR"
    echo "    Version: 3.0"
    echo ""
    echo "================================================================================"
    echo ""
}

# ... [Rest of the functions remain the same as original script]
# [Note: Keep all other functions from the original script unchanged]
# [Only the display functions have been updated for clarity]

# Main function
main_menu() {
    while true; do
        display_header
        
        # Show available VMs
        display_vm_list
        
        # Show main menu
        display_main_menu
        
        read -p "$(print_status "INPUT" "Enter your choice: ")" choice
        
        # Handle menu choice
        # [Keep the same menu handling logic from original script]
        # [Add calls to display functions where appropriate]
        
        case $choice in
            1)
                display_header
                display_os_menu
                # ... rest of create VM logic
                ;;
            0)
                display_goodbye
                exit 0
                ;;
            *)
                # ... handle other cases
                ;;
        esac
    done
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Check dependencies
check_dependencies

# Initialize paths
VM_DIR="${VM_DIR:-$HOME/vms}"
mkdir -p "$VM_DIR"

# Supported OS list
declare -A OS_OPTIONS=(
    ["Ubuntu 22.04"]="ubuntu|jammy|https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img|ubuntu22|ubuntu|ubuntu"
    ["Ubuntu 24.04"]="ubuntu|noble|https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img|ubuntu24|ubuntu|ubuntu"
    ["Debian 11"]="debian|bullseye|https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2|debian11|debian|debian"
    ["Debian 12"]="debian|bookworm|https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2|debian12|debian|debian"
    ["Fedora 40"]="fedora|40|https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-40-1.14.x86_64.qcow2|fedora40|fedora|fedora"
    ["CentOS Stream 9"]="centos|stream9|https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2|centos9|centos|centos"
    ["AlmaLinux 9"]="almalinux|9|https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2|almalinux9|alma|alma"
    ["Rocky Linux 9"]="rockylinux|9|https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2|rocky9|rocky|rocky"
)

# Start the main menu
main_menu
