# Home Dashboard

### **Step 1: Install the Frontend Cards**

* **Download:** In **HACS**, search for and download each card:
  * [Mushroom](https://github.com/piitaya/lovelace-mushroom)
  * [auto-entities](https://github.com/thomasloven/lovelace-auto-entities)
  * [card-mod](https://github.com/thomasloven/lovelace-card-mod)
---

### **Step 2: Render the YAML**

Personal entity IDs in the dashboard are `${HA_...}` placeholders. The real values are in the gitignored `.ha_devices_name` file. To fill them in and copy the result:

---

### **Step 3: Add the Dashboard**

* **Create:** Settings → Dashboards → **+ Add Dashboard** → **New dashboard from scratch** → name it `Home`.
* **Paste:** Open the dashboard → ✏️ → ⋮ → **Raw configuration editor**. Replace everything with the rendered YAML, then **Save**.

---

### **Step 4: Set as Default**

Settings → Dashboards → `Home` → **Set as default**.
