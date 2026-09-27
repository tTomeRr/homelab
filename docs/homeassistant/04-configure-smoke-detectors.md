## 1. Create the binary sensor group

Settings → Devices & services → **Helpers** tab (top) → **+ Create helper** (bottom right) → Group → Binary sensor group.

- Name: `Smoke Detectors`
- Members: add every smoke detector's **Smoke** entity (the MOES one is the `binary_sensor.*` with device class *smoke*)
- "All entities" toggle: **off**

Entity created: `binary_sensor.smoke_detectors`

## 2. Add the template sensor

Edit `configuration.yaml`. Merge into the existing `template:` → `sensor:` list (do not create a second `template:` block):

```yaml
template:
  - sensor:
      - name: "Smoke Detectors Triggered List"
        state: >
          {% set smoke = expand('binary_sensor.smoke_detectors')
             | selectattr('state', 'eq', 'on')
             | map(attribute='entity_id')
             | map('state_attr', 'friendly_name')
             | list %}
          {% if smoke | count == 0 %}
            Clear
          {% else %}
            {{ smoke | join(', ') }}
          {% endif %}
```

Developer Tools → YAML → Check Configuration. If valid, reload template entities or restart Home Assistant.

Verify `sensor.smoke_detectors_triggered_list` exists and shows `Clear`. (A template that outputs the literal text `None` is converted to `unknown` by HA, so `Clear` is used instead.)

## 3. Create the automation

Settings → Automations & Scenes → Create Automation → Edit in YAML. Paste:

```yaml
alias: Smoke Detected
mode: single
triggers:
  - trigger: state
    entity_id: binary_sensor.smoke_detectors
    from: "off"
    to: "on"
actions:
  - action: notify.mobile_app_oneplus_15
    data:
      title: "SMOKE DETECTED"
      message: "Smoke: {{ states('sensor.smoke_detectors_triggered_list') }}"
      data:
        tag: smoke_alarm
        sticky: "true"
        persistent: true
        ttl: 0
        priority: high
        channel: alarm_stream
        importance: high
        color: red
        notification_icon: mdi:smoke-detector-alert
```

Save.

`channel: alarm_stream` plays the alarm sound even when the phone is on silent/DND.

## 4. (Optional) Low battery alert

```yaml
alias: Smoke Detector Low Battery
mode: single
triggers:
  - trigger: numeric_state
    entity_id: sensor.living_room_smoke_detector_battery
    below: 20
actions:
  - action: notify.mobile_app_oneplus_15
    data:
      title: "Smoke detector battery low"
      message: "Living Room smoke detector: {{ trigger.to_state.state }}%"
```

## 5. Android background permissions

Same as the water sensors doc (Battery → **Unrestricted**, **Don't optimize**, Auto-launch enabled). Without it, notifications silently fail.

## 6. Test it

Developer Tools → States → `binary_sensor.living_room_smoke_detector` → set state to `on` → Set State.
Notification should arrive within seconds with alarm sound. Set it back to `off` when done.

Then do a real test: press the detector's test button. Note that a Tuya self-test may only update the **Self test result** sensor and not flip the Smoke sensor. Check the Smoke entity's history to see which it does.

## 7. Adding new smoke detectors later

Settings → Devices & services → Helpers → Smoke Detectors → Edit → add the new entity to Members → Save.
