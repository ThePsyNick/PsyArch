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
ln -sf /mnt/usr/share/zoneinfo/Europe/Rome >> /mnt/etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf
echo "KEYMAP=it" >> /mnt/etc/vconsole.conf
echo "Set an Hostname for the installation: "
read hostprompt
echo $hostprompt >> /mnt/etc/hostname
echo "Set Password for Root User:"
passwd
cd /mnt/
mkdir ./boot/efi
mount /dev/sda1 ./boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=./boot/efi
grub-mkconfig -o ./boot/grub/grub.cfg
echo "Installation Finished!"
