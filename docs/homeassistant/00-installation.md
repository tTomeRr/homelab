# Installing Home Assistant OS on Proxmox

**Guide reference:** [Proxmox Forum — Install Home Assistant OS in a VM](https://forum.proxmox.com/threads/guide-install-home-assistant-os-in-a-vm.143251/)

---

## 1. Obtain the VM Image

1. Open the [Home Assistant alternative installation page](https://www.home-assistant.io/installation/alternative)
2. Right-click the **KVM/Proxmox** link and copy the address
3. In the Proxmox console, download and extract the image:

```bash
wget <ADDRESS>
unxz <file.qcow2.xz>
```

---

## 2. Create the VM

In the Proxmox web UI, create a new VM with the following settings:

| Tab | Setting |
|---------|-------------|
| General | Set VM name and ID, enable **Start at boot** |
| OS | **Do not use any media** |
| System | Machine: `q35`, BIOS: `OVMF (UEFI)`, select EFI storage (e.g. `local-lvm`), **uncheck** Pre-Enroll keys |
| Disks | Delete the SCSI drive and any other disks |
| CPU | Minimum 2 cores |
| Memory | Minimum 4096 MB |
| Network | Leave default unless static/VLAN is required |

> **NOTE:** Confirm and finish, but do **not** start the VM yet.

---

## 3. Attach the Image to the VM

In the Proxmox node console, import the extracted image:

```bash
qm importdisk <VM_ID> <file.qcow2> <EFI_location>
```

Example:

```bash
qm importdisk 205 /home/user/haos_ova-12.0.qcow2 local-lvm
```

Then in the VM's **Hardware** tab:

1. Select the **Unused Disk** and click **Edit**
2. Check **Discard** if using an SSD, then click **Add**

In the VM's **Options** tab:

3. Select **Boot Order** and click **Edit**
4. Check the newly created drive (likely `scsi0`) and uncheck everything else

---

## 4. Boot and Access Home Assistant

1. Start the VM
2. Open the VM shell — if it booted correctly, the Web UI link is displayed
3. Run `network info` in the HAOS console to get the VM IP
4. Navigate to `http://<VM_IP>:8123` in a browser
5. Complete the basic setup (username, password, etc.)

---

## 5. Configure the Reverse Proxy

1. Add the full IP and port of the Home Assistant machine to the Caddyfile
2. In Home Assistant, go to **Settings → Add-ons → Add-on Store** and install **File editor**
3. Edit `configuration.yaml` and add the reverse proxy block:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 192.168.100.0/24
```

4. Save and reboot Home Assistant

---

## Reference Materials

- [Home Assistant — Reverse Proxies](https://www.home-assistant.io/integrations/http/#reverse-proxies)
- [Home Assistant — Configuration Basics](https://www.home-assistant.io/docs/configuration/)
