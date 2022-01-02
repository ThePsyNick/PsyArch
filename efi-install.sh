# Partition the disk and create a EFI (dev/sda1), Swap(dev/sda2) and Root(dev/sda3)
timedatectl set-ntp true
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mkfs.fat -F32 /dev/sda1
mount /dev/sda3 /mnt
swapon /dev/sda2
pacstrap /mnt base linux linux-firmware networkmanager vim sudo
genfstab -U /mnt >> /mnt/etc/fstab
ln -sf /mnt/usr/share/zoneinfo/Europe/Rome >> /mnt/etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf
echo "KEYMAP=it" >> /mnt/etc/vconsole.conf
read hostprompt
echo $hostprompt >> /mnt/etc/hostname
passwd
pacman -S /mnt grub efibootmgr
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/mnt/boot/efi
grub-mkconfig -o /mnt/boot/grub/grub.cfg
echo "Installation Finished!"
