wipefs --all /dev/nvme0n1
sgdisk --zap-all /dev/nvme0n1
fdisk /dev/nvme0n1 # manual
# g                 new empty GPT label (replaces the existing table in memory)
# n  1  ⏎  +1G     partition 1: default start (2048), 1 GiB
# n  2  ⏎  ⏎       partition 2: default start, rest of disk
# t  1  uefi       set p1 type to EFI System  (if 'uefi' isn't accepted, type 1)
# w                write and exit

mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

mount /dev/nvme0n1p2 /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot

pacstrap -K /mnt base linux linux-firmware \
    intel-ucode \
    networkmanager \
    vim sudo \
    grub efibootmgr dosfstools

genfstab -U /mnt >> /mnt/etc/fstab