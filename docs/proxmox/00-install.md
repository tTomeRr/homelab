# Proxmox Installation Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Creating Bootable USB](#creating-bootable-usb)
3. [Installation Steps](#installation-steps)
4. [Accessing Proxmox](#accessing-proxmox)
5. [Adding ISO Images](#adding-iso-images-to-proxmox)
6. [Creating Virtual Machines](#creating-new-virtual-machine)
7. [Reference Materials](#reference-materials)

---

## Prerequisites
- Proxmox ISO (Download from official Proxmox website)
- USB stick (minimum 8GB)
- Rufus software for creating bootable USB

## Creating Bootable USB
1. Download and install Rufus from [rufus.ie](https://rufus.ie/en/)
2. Create a bootable USB with the Proxmox ISO

## Installation Steps
1. Insert USB into target server and boot from the Rufus USB
2. Follow installation wizard
   - **Important**: Note down the IP address assigned to Proxmox
   - **Important**: Remember the root password you set

## Accessing Proxmox
1. Open web browser
2. Navigate to `https://[proxmox-ip]:8006`
   - Example: `https://192.168.1.50:8006`
3. Login with root credentials

## Adding ISO Images to Proxmox

### Upload Process
1. Navigate to: Datacenter → Proxmox → local(proxmox) → ISO Images
2. Choose upload method:
   - Option 1: Upload from local computer
   - Option 2: Download from URL

## Creating New Virtual Machine

### VM Configuration Steps
1. Click "Create VM" button
2. General:
   - Set VM ID (auto-generated)
   - Enter VM name
   - Select ISO file
3. OS:
   - Select operating system
4. System:
   - Machine: Set to q35
   - BIOS: Change to OVMF (UEFI)
5. Disks:
   - Set desired disk size
6. CPU:
   - Configure CPU cores and sockets
7. Memory:
   - Set RAM allocation
8. Network:
   - Keep default settings

### VM OS Installation
1. During OS installation:
   - Choose manual IP configuration
   - Configure IP according to network diagram
   - **Do not use DHCP**

## Reference Materials
- [Proxmox Installation Guide Video](https://www.youtube.com/watch?v=sZcOlW-DwrU)
