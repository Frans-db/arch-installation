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

# Random stuff

**For formatting SD card**
```bash
sudo pacman -S dosfstools
```

```bash
sudo pacman -S yt-dlp
```