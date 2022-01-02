loadkeys it
timedatectl set-ntp true
# Partition disk with a EFI(dev/sda1), Swap(dev/sda2) and Root(dev/sda3) partition
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mkfs.fat -F32 /dev/sda1
mount /dev/sda3 /mnt
swapon /dev/sda2
pacstrap /mnt base linux linux-firmware networkmanager vim sudo
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Rome >> /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=it" >> /etc/vconsole.conf
read hostprompt
echo $hostprompt >> /etc/hostname
passwd
pacman -S grub efibootmgr
mkdir /boot/efi
mount /dev/sda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
exit
echo "Installation Finished!"
