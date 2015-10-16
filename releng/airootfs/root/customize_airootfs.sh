#!/bin/bash

set -e -u

# Locale
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf

# virtual console
echo "KEYMAP=us" > /etc/vconsole.conf

# Time and clock
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc --utc

# virtual console
echo "KEYMAP=us" > /etc/vconsole.conf

# hostname
echo "pacbang" > /etc/hostname
echo -e "#<ip-address>\t<hostname.domain.org>\t<hostname>\n127.0.0.1\tlocalhost.localdomain\tlocalhost\tpacbang\n::1\tlocalhost.localdomain\tlocalhost\tpacbang" > /etc/hosts

# root and live user
usermod -s /bin/bash root
cp -aT /etc/skel/ /root/
useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash paclive
#chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel
chown -R paclive:users /home/paclive

# Uncomment mirrors and amend journald
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

# Enable services
systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

