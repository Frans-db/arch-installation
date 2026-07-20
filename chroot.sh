ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
hwclock --systohc

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "precision5560" > /etc/hostname

# Networking
systemctl enable NetworkManager

# Install GRUB for UEFI.
# Your EFI System Partition is mounted at /boot.
grub-install \
  --target=x86_64-efi \
  --efi-directory=/boot \
  --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

# This remains interactive and asks you for the root password.
passwd