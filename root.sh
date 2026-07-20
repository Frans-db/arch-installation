# Wipe existing partitions
wipefs --all /dev/nvme0n1
sgdisk --zap-all /dev/nvme0n1

# Create new partitions:
# 1. 1GB EFI
# 2. Remaining space for Linux root partition
sgdisk \
  --clear \
  --new=1:0:+1G \
  --typecode=1:ef00 \
  --change-name=1:"EFI System Partition" \
  --new=2:0:0 \
  --typecode=2:8300 \
  --change-name=2:"Linux root" \
  /dev/nvme0n1

# Reread partition table
partprobe /dev/nvme0n1
# Print summary of the partition table
sgdisk --print /dev/nvme0n1

# Encrypt root partition
cryptsetup -v luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 root

# Format partitions
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/mapper/root

# Mount partitions
mount /dev/mapper/root /mnt 
mount --mkdir /dev/nvme0n1p1 /mnt/boot

# Install essential packages
pacstrap -K /mnt \
    base linux linux-firmware intel-ucode \
    networkmanager \
    vim sudo \
    grub efibootmgr dosfstools \
    cryptsetup

# Generate fstab
genfstab -U /mnt > /mnt/etc/fstab

# Install chroot into environment
install -Dm700 \
  "chroot.sh" \
  /mnt/root/chroot.sh

# Execute chroot
arch-chroot -S /mnt /root/chroot.sh

# Remove chroot
rm /mnt/root/chroot.sh

umount -R /mnt

echo "Installation complete."