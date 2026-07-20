disk=/dev/nvme0n1

wipefs --all "$disk"
sgdisk --zap-all "$disk"

sgdisk \
  --clear \
  --new=1:0:+1G \
  --typecode=1:ef00 \
  --change-name=1:"EFI System Partition" \
  --new=2:0:0 \
  --typecode=2:8300 \
  --change-name=2:"Linux root" \
  "$disk"

partprobe "$disk"
sgdisk --print "$disk"

mkfs.fat -F32 "$disk"p1
mkfs.ext4 "$disk"p2

mount "$disk"p2 /mnt
mount --mkdir "$disk"p1 /mnt/boot

pacstrap -K /mnt base linux linux-firmware intel-ucode \
    networkmanager \
    vim sudo \
    grub efibootmgr dosfstools

genfstab -U /mnt > /mnt/etc/fstab

install -Dm700 \
  "chroot.sh" \
  /mnt/root/chroot.sh

# Execute it inside the installed system.
arch-chroot -S /mnt /root/chroot.sh

# Do not leave the installer script in the installed system.
rm /mnt/root/chroot.sh

umount -R /mnt

echo "Installation complete."