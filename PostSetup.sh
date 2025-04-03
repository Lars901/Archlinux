#!/usr/bin/env bash
username=$(id -u -n 1000)
builddir=$(pwd)

sudo pacman -s update
-------------------------------------------------------------------------
                    Enabling Essential Services
-------------------------------------------------------------------------
"
systemctl enable cups.service
echo "  Cups enabled"
ntpd -qg
systemctl enable ntpd.service
echo "  NTP enabled"
systemctl disable dhcpcd.service
echo "  DHCP disabled"
systemctl stop dhcpcd.service
echo "  DHCP stopped"
systemctl enable NetworkManager.service
echo "  NetworkManager enabled"
systemctl enable bluetooth
echo "  Bluetooth enabled"
systemctl enable avahi-daemon.service
echo "  Avahi enabled"

PKGS=(
'alsa-utils' # audio utils
'ark' # compression
'apt-transport-https' #Dependecy for Brave
'kio-audiocd' 
'autoconf' # build
'automake' # build
'bash-completion'
'binutils'
'bison'
'bluedevil'
'bluez'
'breeze'
'btrfs-progs'
'celluloid' # video players
'cups' #Common Unix Printing System
'curl'
'dialog'
'dosfstools'
'fonts-terminus'
'flex'
'fuse3'
'fuseiso'
'gamemode'
'gdebi-core'
'gcc'
'gdisk'
'handbrake'
'haveged'
'htop'
'nftables'
'inkscape' #Vector Graphics Editor
'cabextract'
'openjdk-17-jdk' # Java 17
'openjdk-17-jre' #Java 17 jre
'qt5-style-kvantum'
'libavcodec-extra' # Extra codecs
'libnewt-dev'
'libtool'
'libcupsimage2' #Canon Printer driver requirement
'firmware-linux-nonfree' #Firmware
'lsof'
#'lutris'
'lzop'
'm4'
'make'
'milou'
'nano'
'ntfs-3g'
'ntp'
'ntpdate'
'okular'
'netcat-openbsd'
'os-prober'
'obs-studio'
'p7zip'
'patch'
'pkgconf' 
'print-manager'
'python3-pip'
'qemu-kvm'
'libvirt-clients' #Dependecy for quemu
'libvirt-daemon-system' #Dependecy for quemu
'bridge-utils' #Dependecy for quemu
'virtinst' #Dependecy for virt-manager
'libvirt-daemon' #Dependecy for virt-manager
'virt-manager' 
'rsync'
'snapper' #Linux filesystem snapshot management tool
'systemsettings'
'fonts-terminus'
'flatpak'
'flameshot'
'traceroute'
'telegram-desktop' #Instant messaging client
'ufw'
'unrar'
'unzip'
'usbutils'
'vulkan-tools'
'virt-manager'
'virt-viewer'
'wget'
'kde-zeroconf'
'ktorrent'
'zip'
'g++'
'libx11-dev'
'libvirglrenderer1'
'virgl-server'
'libxext-dev'
'qtbase5-dev'
'libqt5svg5-dev'
'libqt5x11extras5-dev'
'libkf5windowsystem-dev'
'qttools5-dev-tools'
'libsdl2-2.0' 
'libsdl2-dev' 
'libalut-dev'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo apt -y install "$PKG"
done

# Graphics Drivers find and install
if lspci | grep -E "NVIDIA|GeForce"; then
    sudo apt -y install nvidia nvidia-xconfig
elif lspci | grep -E "Radeon"; then
    sudo apt -y install xserver-xorg-video-amdgpu firmware-amd-graphics
elif lspci | grep -E "Integrated Graphics Controller"; then
    sudo apt -y install libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi

#Enable Dvd playback
wget http://ftp.de.debian.org/debian/pool/contrib/libd/libdvd-pkg/libdvd-pkg_1.4.3-1-1_all.deb
wget http://ftp.de.debian.org/debian/pool/main/libd/libdvdread/libdvdread8_6.1.3-1_amd64.deb
sudo dpkg -i libdvd-pkg_1.4.3-1-1_all.deb
sudo dpkg -i libdvdread8_6.1.3-1_amd64.deb
sudo dpkg-reconfigure libdvd-pkg

#Windows Media Codecs
wget http://www.deb-multimedia.org/pool/non-free/w/w64codecs/w64codecs_20071007-dmo2_amd64.deb
sudo dpkg -i w64codecs_20071007-dmo2_amd64.deb

#Flatpak Requirements
sudo apt install -y plasma-discover-backend-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Making .config and Moving config files and background to Pictures/Wallpapers
cd "$builddir" || exit
mkdir -p "/home/$username/.config"
mkdir -p "/home/$username/.fonts"
mkdir -p "/home/$username/Pictures"
mkdir -p "/home/$username/Wallpapers"
mkdir -p /usr/share/sddm/themes
sudo mkdir -p "/usr/share/sddm"
cd $builddir
#cd /Wallpapers
#cp -R *.jpg /$HOME/$USER/Pictures/Wallpapers/
chown -R "$username:$username" "/home/$username"

#Nala
sudo nala fetch
# Installing fonts
cd "$builddir" || exit
git clone https://github.com/SpudGunMan/segoe-ui-linux
sudo nala install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d "/home/$username/.fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d "/home/$username/.fonts"
mv dotfonts/fontawesome/otfs/*.otf "/home/$username/.fonts/"
chown "$username:$username" "/home/$username/.fonts/*"
sudo nala install fonts-crosextra-carlito fonts-crosextra-caladea -y

# Reloading Font cache
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors || exit
chmod +x ./install.sh
./install.sh
cd "$builddir" || exit
rm -rf Nordzy-cursors

# Install  Layan Cursors
git clone https://github.com/vinceliuice/Layan-cursors
cd Layan-cursors || exit
chmod +x ./install.sh
sudo ./install.sh
cd "$builddir" || exit
rm -Layan-cursors 

# Download Nordic Theme
cd /usr/share/themes/ || exit
sudo git clone https://github.com/EliverLara/Nordic.git


#________________________________________________________
#AppImg
wget https://github.com/HarbourMasters/Shipwright/releases/download/9.0.0/SoH-Blair-Alfa-Linux.zip
tar -xfv SoH-Sulu-Bravo-Linux-Performance.zip
wget https://evilgames.eu/texture-packs/files/oot-reloaded-v10.4.2-soh-otr-hd.7z 
#wget https://evilgames.eu/texture-packs/files/oot-reloaded-v10.4.2-soh-otr-4k.7z
#___________________________________
#Flatpaks

#Flatseal addon
flatpak install -y flathub com.github.tchx84.Flatseal

#KGet Download manager
flatpak install -y flathub org.kde.kget
#Spotify
flatpak install -y flathub com.spotify.Client

#LibreOffice
flatpak install -y flathub org.libreoffice.LibreOffice

#RetroArch
flatpak install -y  --user flathub org.libretro.RetroArch
flatpak update --user org.libretro.RetroArch

#Dolphin Emu
flatpak install -y flathub org.DolphinEmu.dolphin-emu
cd "/home/$username"
wget https://downloads.romspedia.com/roms/Legend%20of%20Zelda%2C%20The%20-%20The%20Wind%20Waker%20%28USA%29.7z
wget https://www.mediafire.com/file/uijj3i3349h8j2j/gba_bios.zip/file

#Ryujinx Emu and fix vm.max_map count for games
flatpak install -y flathub org.ryujinx.Ryujinx
#wget https://drive.google.com/file/d/1i67zoVVm9AAYRgoKIRsPcPNVETLvseIU/view?usp=sharing
#wget https://drive.google.com/file/d/1HiSTp90tiBFh3ELVbjsX-8SeUkOodxKz/view?usp=sharing
#sudo sysctl -w vm.max_map_count=1048576

#Citra Emu
flatpak install -y flathub org.citra_emu.citra

#RPCS3 Emu
flatpak install -y flathub net.rpcs3.RPCS3
cd "$builddir" || exit
wget http://dus01.ps3.update.playstation.net/update/ps3/image/us/2023_0228_05fe32f5dc8c78acbcd84d36ee7fdc5b/PS3UPDAT.PUP

#MineCraft
flatpak install -y flathub com.mojang.Minecraft
#Bedrock Edition
flatpak install -y flathub io.mrarm.mcpelauncher

#Discord
flatpak install -y flathub com.discordapp.Discord

#Wallpaper downloader
flatpak install -y flathub es.estoes.wallpaperDownloader

#Bible applications
flatpak install -y flathub org.xiphos.Xiphos

#Github Desktop 
flatpak install -y flathub io.github.shiftey.Desktop

#MakeMkv
flatpak install -y flathub com.makemkv.MakeMKV

#Thunderbird Mailclient
flatpak install -y flathub org.mozilla.Thunderbird

#Chatterino
flatpak install -y chatterino

#Taskmanager
flatpak install -y flathub net.nokyan.Resources
#_______________________________________________________________________#

#sudo systemctl status libvirtd.service
sudo adduser $User libvirt
sudo adduser $User libvirt-qemu
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

#SoH
cd cd "$builddir" || exit
wget https://github.com/HarbourMasters/Shipwright/releases/download/8.0.4/SoH-MacReady-Echo-Linux-Performance.zip

#extra programs
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update
sudo nala install codium -y
cd "$builddir" || exit
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.21.1/fastfetch-linux-amd64.deb

#Brave Browser
sudo nala install curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo nala install -y brave-browser
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

#Fonts
cd "$builddir"
wget http://ftp.de.debian.org/debian/pool/contrib/m/msttcorefonts/ttf-mscorefonts-installer_3.8.1_all.deb
sudo dpkg -i ttf-mscorefonts-installer_3.8.1_all.deb
wget http://plasmasturm.org/dl/vistafonts-... | bash #VistaFonts

#sudo systemctl status libvirtd.service
sudo adduser $User libvirt
sudo adduser $User libvirt-qemu
sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin

# Download Nordic Theme
cd /usr/share/themes/
sudo git clone https://github.com/EliverLara/Nordic.git

#Multilib support
sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install \
      wine \
      wine32 \
      wine64 \
      libwine \
      libwine:i386 \
      fonts-wine

#sudo apt install steam -y (Black Window CSGO)
sudo nala install -y build-essential dkms linux-headers-amd64
sudo nala install -y mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386
sudo nala install -y libxtst6:i386 libxrandr2:i386 libglib2.0-0:i386 libgtk2.0-0:i386 libpulse0:i386 libgdk-pixbuf2.0-0:i386 libcurl4-openssl-dev:i386 libopenal1:i386 libusb-1.0-0:i386 libdbus-glib-1-2:i386 
sudo nala install -y linux-headers-$(uname -r)
sudo apt purge -y firefox-esr
sudo apt purge -y konqueror
sudo update-alternatives --config editor

#Minecraft Java Edition Launcher
#wget https://launcher.mojang.com/download/Minecraft.deb
#sudo dpkg -i Minecraft.deb
#Steam Flatpak version
flatpak install -y flathub com.valvesoftware.Steam

#Fix time when dualbooting with Windows 10+
sudo timedatectl set-local-rtc 1