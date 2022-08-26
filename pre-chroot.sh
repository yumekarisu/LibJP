#! /bin/bash

echo installing base

timedatectl set-ntp true

echo partitions disk?\n yes/no
read partition

if [[ $partition == "yes" ]]then;
	cfdisk
elif [[ $partition == "no" || $partition != "yes" ]]then;
	echo continue to formating
fi

lsblk

echo enter boot partition:
read boot

echo enter root partition:
read root

echo enter home partition:
read home

echo enter swap partition
read swap

echo formating
mkfs.ext4 $root
mkfs.fat -F 32 $boot
echo do you already have a home partition? If not, the script will format the home partition you specified before\n [WARNING! ALL DATA ON THAT PARTITION WILL BE WIPED]\nyes/no
read frmthome

if [[ $frmthome == "yes" ]]then;
mkfs.ext4
elif [[ $frmthome == "no" || $frmthome !="yes" ]]then;
echo skip formating /home
fi

mkswap $swap

echo mounting
mount $root /mnt
mount --mkdir $boot /mnt/boot/efi
mount --mkdir $home /mnt/home
swapon $swap
#

echo starting pacstrap

pacstrap /mnt base base-devel linux-lts linux-firmware efibootmgr grub osprober neovim ntfs-3g git curl man-db

genfstab -U /mnt >> /mnt/etc/fstab

cp after-chroot.sh /mnt

arch-chroot /mnt

