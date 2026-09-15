#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Partition disk, pacstrap base system, generate fstab
"$SCRIPT_DIR/root/disk.sh"
"$SCRIPT_DIR/root/packages.sh"
"$SCRIPT_DIR/root/fstab.sh"

# Install chroot scripts into environment and run them in order
for script in locale network grub users; do
  install -Dm700 \
    "$SCRIPT_DIR/chroot/$script.sh" \
    "/mnt/root/$script.sh"

  arch-chroot -S /mnt "/root/$script.sh"

  rm "/mnt/root/$script.sh"
done

umount -R /mnt

echo "Installation complete."
