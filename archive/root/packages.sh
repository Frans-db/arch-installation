#!/usr/bin/env bash
set -euo pipefail

# Install packages
# Essential packages
pacstrap -K /mnt base linux linux-firmware intel-ucode
# Bootloader
pacstrap -K /mnt grub efibootmgr
# Network
pacstrap -K /mnt networkmanager
# Tools
pacstrap -K /mnt vim sudo openssh
