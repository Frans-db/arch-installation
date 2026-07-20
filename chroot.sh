# Set timezone
ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
hwclock --systohc

# Enable en_us-UTF-8
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "precision5560" > /etc/hostname

# Networking
systemctl enable NetworkManager

mkdir -p /etc/mkinitcpio.conf.d

cat > /etc/mkinitcpio.conf.d/encryption.conf <<'EOF'
HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)
EOF
mkinitcpio -P

luks_uuid="$(cryptsetup luksUUID "$encrypted_partition")"

sed -i \
  "s|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX=\"rd.luks.name=${luks_uuid}=root root=/dev/mapper/root\"|" \
  /etc/default/grub

# Install GRUB for UEFI.
grub-install \
  --target=x86_64-efi \
  --efi-directory=/boot \
  --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

# This remains interactive and asks you for the root password.
passwd