#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# TODO: run root/*.sh scripts in order (partitioning, pacstrap, etc.)
# TODO: install chroot/*.sh into /mnt and run them via arch-chroot
