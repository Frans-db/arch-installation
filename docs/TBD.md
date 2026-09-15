# Bluetooth

## Installing

```bash
sudo pacman -S bluez bluez-utils
systemctl enable --now bluetooth.service
```

## Enabling

```bash
bluetoothctl
scan on
pair MAC_address
trust MAC-address
```
