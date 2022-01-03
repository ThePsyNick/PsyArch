loadkeys it
timedatectl set-ntp true
# Partition disk with a EFI(dev/sda1), Swap(dev/sda2) and Root(dev/sda3) partition
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mkfs.fat -F32 /dev/sda1
mount /dev/sda3 /mnt
swapon /dev/sda2
pacstrap /mnt base linux linux-firmware networkmanager vim sudo grub efibootmgr
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
expect ln -sf /usr/share/zoneinfo/Europe/Rome >> /etc/localtime
expect hwclock --systohc
expect echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
expect echo "LANG=en_US.UTF-8" >> /etc/locale.conf
expect echo "KEYMAP=it" >> /etc/vconsole.conf
echo "Set an Hostname for the installation: "
read hostprompt
echo $hostprompt >> /etc/hostname
echo "Set Password for Root User:"
expect passwd
expect mkdir /boot/efi
expect mount /dev/sda1 /boot/efi
expect grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
expect grub-mkconfig -o /boot/grub/grub.cfg
expect exit
echo "Installation Finished!"
