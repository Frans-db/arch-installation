#!/usr/bin/env bash
set -euo pipefail

# Generate fstab
genfstab -U /mnt > /mnt/etc/fstab
