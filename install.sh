#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Partition disk, pacstrap base system, generate fstab
"$SCRIPT_DIR/root/install.sh"

# Install chroot script into environment
install -Dm700 \
  "$SCRIPT_DIR/chroot/install.sh" \
  /mnt/root/install.sh

# Execute chroot
arch-chroot -S /mnt /root/install.sh

# Remove chroot script
rm /mnt/root/install.sh

umount -R /mnt

echo "Installation complete."
