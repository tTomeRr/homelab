### **Step 1: Add the USB in Proxmox**

* **Connect Hardware:** Plug Dongle into Proxmox server
* **Navigate Proxmox:** Open the Proxmox Web UI, select Home Assistant VM, and go to the **Hardware** tab.
* **Add Device:** Click **Add** > **USB Device**.
* **Select Dongle:** Choose **Use USB Vendor/Device ID**. Click **Add**.
* **Apply Changes:** Reboot the Home Assistant VM from Proxmox UI.

---

### **Step 2: Set Up in Home Assistant**

* **Navigate Settings:** Open Home Assistant, go to **Settings** > **Devices & services**, and click **Add Integration**.
* **Choose Platform:** Search for and select either **Zigbee Home Automation (ZHA)** or **Zigbee2MQTT**.
* **Configure ZHA:** Select the Sonoff serial port (usually starts with `/dev/serial/by-id/...`) and complete the on-screen setup.

---

### **Step 3: Flash the Sonoff Dongle**

* **Install Add-on:** In Home Assistant, navigate to **Settings** > **Add-ons** and install the [Sonoff Dongle Flasher](https://github.com/iHost-Open-Source-Project/hassio-ihost-addon/tree/master/hassio-ihost-sonoff-dongle-flasher) add-on.
* **Run Flasher:** Open the add-on and follow the on-screen instructions to flash the dongle firmware.
* **Verify:** Confirm the dongle is detected after flashing completes.
