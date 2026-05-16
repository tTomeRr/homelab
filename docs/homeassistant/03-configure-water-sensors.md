## 1. Create the binary sensor group

Settings → Devices & Services → Helpers → Create Helper → Group → Binary sensor group.

- Name: `Water Leaks`
- Members: add every moisture sensor
- "All entities" toggle: **off**

Entity created: `binary_sensor.water_leaks`

## 2. Add the template sensor

Edit `configuration.yaml`. Merge into existing `template:` block (do not create a second one):

```yaml
template:
  - sensor:
      - name: "Wet Water Sensors List"
        state: >
          {% set wet = expand('binary_sensor.water_leaks')
             | selectattr('state', 'eq', 'on')
             | map(attribute='entity_id')
             | map('state_attr', 'friendly_name')
             | list %}
          {% if wet | count == 0 %}
            None
          {% else %}
            {{ wet | join(', ') }}
          {% endif %}
```

Developer Tools → YAML → Check Configuration. If valid, reload template entities or restart Home Assistant.

Verify `sensor.wet_water_sensors_list` exists and shows `None`.

## 3. Create the automation

Settings → Automations & Scenes → Create Automation → Edit in YAML. Paste:

```yaml
alias: Water Leak Detected
description: Alert when any moisture sensor goes wet
mode: single
triggers:
  - platform: state
    entity_id: binary_sensor.water_leaks
    from: "off"
    to: "on"
conditions: []
actions:
  - action: notify.mobile_app_YOUR_PHONE
    data:
      title: "WATER LEAK DETECTED"
      message: "Wet: {{ states('sensor.wet_water_sensors_list') }}"
      data:
        tag: water_leak
        sticky: "true"
        persistent: true
        ttl: 0
        priority: high
        channel: alarm_stream
        importance: high
        color: red
        notification_icon: mdi:water-alert
```

Replace `notify.mobile_app_YOUR_PHONE` with your actual notify service. Save.

## 4. Configure Android background permissions

Required or the Companion app will be killed and notifications will silently fail.

- Settings → Apps → Home Assistant → Battery → **Unrestricted**
- Settings → Battery → Battery optimization → Home Assistant → **Don't optimize**
- Settings → Apps → Special app access → Auto-launch (if present) → enable Home Assistant

## 5. Test it

Developer Tools → States → pick any moisture sensor → set state to `on` → Set State.
Notification should arrive within seconds with alarm sound. Set the state back to `off` when done.

## 6. Adding new water sensors later

Settings → Helpers → Water Leaks → Edit → add the new entity to Members → Save.
