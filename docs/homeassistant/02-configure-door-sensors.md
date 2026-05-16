# Alert on Open Doors/Windows When Leaving Home

## 1. Create a binary sensor group

**Settings > Devices & Services > Helpers > Create Helper > Group > Binary sensor group**

- Name: `All Openings`
- Members: all door/window sensors
- All entities: OFF

Creates `binary_sensor.all_openings`.

## 2. Add template sensor to `configuration.yaml`

```yaml
template:
  - sensor:
      - name: "Open Openings List"
        state: >
          {% set openings = expand('binary_sensor.all_openings')
             | selectattr('state', 'eq', 'on')
             | map(attribute='entity_id')
             | map('state_attr', 'friendly_name')
             | list %}
          {% if openings | count == 0 %}
            None
          {% else %}
            {{ openings | join(', ') }}
          {% endif %}
```


Then **Developer Tools > YAML > Check Configuration**, then **Reload -> Restart** 

Verify `sensor.open_openings_list` exists and shows `None` when closed, friendly name when open.

## 3. Create the automation

**Settings > Automations & Scenes > Create > Empty > Edit in YAML**. Replace `YOUR_PERSON_NAME` and `YOUR_PHONE_NAME`:

```yaml
alias: Alert - Openings Open When Leaving Home
mode: single
triggers:
  - platform: zone
    entity_id: person.YOUR_PERSON_NAME
    zone: zone.home
    event: leave
conditions:
  - condition: state
    entity_id: binary_sensor.all_openings
    state: "on"
actions:
  - action: notify.mobile_app_YOUR_PHONE_NAME
    data:
      title: "⚠️ You left something open"
      message: "Open: {{ states('sensor.open_openings_list') }}"
      data:
        tag: openings-alert
        priority: high
        ttl: 0
```

## 4. Test

Open a door, check `sensor.open_openings_list` updates. Then walk outside your zone. Check **Automation > Traces** to confirm.

## Adding sensors later

Edit `All Openings` group, add the entity. Done.
