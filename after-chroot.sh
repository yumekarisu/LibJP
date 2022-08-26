#! /bin/bash

ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

hwclock --systohc

nvim /etc/locale.gen

locale-gen

echo "LANG=ja_JP.UTF-8" >> /etc/locale.conf

echo "yumeka-arch" >> /etc/hostname

grub-install --target=x86_64-efi /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

echo done installing base system. Continue installing wm?\n yes/no
read towm

if [[ towm == "no" ]]then;
	exit 1
fi


x11="xorg-xserver xorg-xsetroot xorg-xinit bspwm sxhkd polybar feh xclip maim"

wayland="wayland xorg-xwayland wayland-protocols wlroots wl-clipboard"

waylandAur="river-git"

audio="pipewire pipewire-pulse pipewire-alsa lib32-pipewire wireplumber pavucontrol"

graphics="mesa lib32-mesa xf86-video-amdgpu vulkan-intel \
	vulkan-radeon lib32-vulkan-intel lib32-vulkan-radeon libva-intel-driver"

fonts="ttf-dejavu ttf-liberation noto-fonts noto-fonts-extra \
	noto-fonts-cjk noto-fonts-emoji"

browser="firefox tor-browser qbittorrent wget \ 
	network-manager-applet dnscrypt-proxy \
	"

file="pcmanfm gvfs xarchiever gvfs-mtp tumbler poppler-glib \
	ffmpegthumbnailer gnome-epub-thumbnailer unzip unrar"

terminal="kitty zsh zsh-completions neovim neofetch go docker git curl"

media="mpd mpv"

misc="dunst python-gobject cronie breeze-icons \
	adwaita-qt5 adwaita-qt6 lxappearance \
	qt5ct qt6ct redshift"

polkit="polkit polkit-gnome"

japanese="fcitx5-im fcitx5-mozc"

gaming="steam gamemode lib32-gamemode schedtool wine-stagging winetricks"

winedep="giflib lib32-giflib libpng lib32-libpng \
	libldap lib32-libldap gnutls lib32-gnutls \
mpg123 lib32-mpg123 openal lib32-openal v4l-utils \
lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
lib32-libgpg-error alsa-plugins lib32-alsa-plugins \ 
alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
sqlite lib32-sqlite libxcomposite lib32-libxcomposite \
libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader \
libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs \
vulkan-icd-loader lib32-vulkan-icd-loader"

aur="discord-canary-electron-bin \
	firefox-profile-switcher-connector-bin \
	yt-dlp schedtoold mangohud lib32-mangohud \
	goverlay-bin spotify \
	vimpc whatsapp-nativefier \
	an-anime-game-launcher-bin lf \ 
	networkmanager-iwd green-tunnel \
	gdu"

AurX11="betterlockscreen"

git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
cd

echo What you want to install:\n 1. X11 \n 2. Wayland

read n

if [[ n = 1 ]]then;
	echo installing x11
	pacman -Syu --needed $x11 $audio $graphics $fonts $browser \
		$file $terminal $media $misc $polkit $japanese $gaming \
		$winedep
	yay -S $aur $AurX11 --sudoloop
elif [[ n = 2 ]]then;
	echo wayland is still not complete
	#pacman -Syu --needed $wayland $audio $graphics $fonts $browser \
		$file $terminal $media $polkit $japanese $gaming \
		$winedep
	#yay -S $aur $WaylandAur --sudoloop
fi
	
systemctl enable iwd.service
systemctl enable NetworkManager
systemctl enable docker.service
systemctl enable schedtoold.service
