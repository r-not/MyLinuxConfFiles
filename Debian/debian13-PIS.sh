#!/bin/bash
# Debian 13 Cinnamon Post-Install Script with Menu
# Run: bash debian13_setup.sh

GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

echo "${GREEN}=== Updating System ===${NC}"
sudo apt update && sudo apt install -y netselect-apt && sudo netselect-apt && sudo apt full-upgrade -y
sudo apt autoremove --purge -y

echo "${GREEN}=== Enabling Non-Free Firmware ===${NC}"
sudo sed -i 's/main$/main contrib non-free-firmware/' /etc/apt/sources.list
sudo sed -i 's/main contrib$/main contrib non-free-firmware/' /etc/apt/sources.list
sudo apt update

echo "${GREEN}=== Installing General Firmware ===${NC}"
sudo apt install -y firmware-linux firmware-linux-nonfree firmware-misc-nonfree dkms linux-headers-$(uname -r) intel-microcode amd64-microcode mesa-utils
    
#echo -e "${GREEN}=== Installing Intel Graphics Drivers ===${NC}"
#sudo apt install -y xserver-xorg-video-intel mesa-utils libva-intel-driver intel-media-va-driver vainfo

#echo -e "${GREEN}=== Installing AMD Graphics Drivers ===${NC}"
#sudo apt install -y xserver-xorg-video-amdgpu mesa-vulkan-drivers mesa-utils vainfo firmware-amd-graphics

echo -e "${GREEN}=== Installing Essentials ===${NC}"
sudo apt install -y curl wget git build-essential gnome-software synaptic gdebi gparted gnome-disk-utility apt-xapian-index policykit-1-gnome libfuse2 

echo -e "${GREEN}=== Installing Additional Packages ===${NC}"
sudo apt install -y libreoffice libreoffice-impress libreoffice-writer libreoffice-calc celluloid rhythmbox gimp gimp-data gimp-data-extras inkscape bleachbit gedit gedit-plugins gedit-plugins-common nala p7zip p7zip-full unzip

echo -e "${GREEN}=== Installing Multimedia Codecs ===${NC}"
echo "Downloading and installing deb-multimedia keyring..."
sudo wget -qO /tmp/dmo-keyring.deb https://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2024.9.1_all.deb && sudo dpkg -i /tmp/dmo-keyring.deb && echo -e "Types: deb\nURIs: https://www.deb-multimedia.org\nSuites: trixie\nComponents: main non-free\nSigned-By: /usr/share/keyrings/deb-multimedia-keyring.pgp\nEnabled: yes" | sudo tee /etc/apt/sources.list.d/dmo.sources >/dev/null
sudo apt update && sudo apt install -y vlc ffmpeg libavcodec-extra libdvdcss2 gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly audacious audacious-plugins handbrake-gtk kodi

echo -e "${GREEN}=== Installing Localsend ===${NC}"
wget -O localsend.deb https://github.com/localsend/localsend/releases/download/v1.17.0/LocalSend-1.17.0-linux-x86-64.deb;dpkg -i localsend.deb 


echo -e "${GREEN}=== Tweaking Login Greeter ===${NC}"
sudo grep -q '^greeter-hide-users=' /usr/share/lightdm/lightdm.conf.d/01_debian.conf && sudo sed -i 's/^greeter-hide-users=.*/greeter-hide-users=false/' /usr/share/lightdm/lightdm.conf.d/01_debian.conf || echo "greeter-hide-users=false" | sudo tee -a /usr/share/lightdm/lightdm.conf.d/01_debian.conf

echo -e "${GREEN}=== Installing Cinnamon Themes ===${NC}"
wget http://packages.linuxmint.com/pool/main/m/mint-themes/mint-themes_1.8.3_all.deb
wget http://packages.linuxmint.com/pool/main/m/mint-x-icons/mint-x-icons_1.5.3_all.deb
sudo apt install -y mint-y-icons
#wget http://packages.linuxmint.com/pool/main/m/mint-y-icons/mint-y-icons_1.3.7_all.deb
sudo dpkg -i mint-themes_1.8.3_all.deb mint-x-icons_1.5.3_all.deb mint-y-icons_1.3.7_all.deb
rm -rf mint-themes_1.8.3_all.* mint-x-icons_1.5.3_all.*

echo -e "${GREEN}=== Installing Fonts ===${NC}"
sudo apt install -y fonts-noto fonts-noto-color-emoji fonts-noto-extra fonts-noto-unhinted    
sudo cd /tmp;wget --no-check-certificate https://github.com/r-not/unibnfonts/archive/master.tar.gz -O ubf.tar.gz;sudo tar -xvf ubf.tar.gz -C /usr/share/fonts/;rm ubf.tar.gz
cd /tmp;wget --no-check-certificate https://raw.githubusercontent.com/r-not/MyLinuxConfFiles/refs/heads/master/Common-Configs/bn-font-set.sh -O bn-font-set.sh;sh ./bn-font-set.sh

echo -e "${GREEN}=== Installing Browsers ===${NC}"
sudo apt remove --purge firefix-esr*
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'
FILE="/etc/apt/sources.list.d/mozilla.list"
LINE='deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main'
sudo touch "$FILE"
grep -qxF "$LINE" "$FILE" || echo "$LINE" | sudo tee -a "$FILE" > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
sudo apt update && sudo apt install -y firefox firefox-l10n-bn chromium
curl -fsS https://dl.brave.com/install.sh | sh

echo -e "${GREEN}=== Installing Power Management Tools ===${NC}"
sudo apt install -y tlp tlp-rdw
sudo systemctl enable tlp

echo -e "${GREEN}=== Installing Timeshift (Backup Tool) ===${NC}"
sudo apt install -y timeshift

echo -e "${GREEN}=== Enabling Flatpak ===${NC}"
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo -e "${GREEN}=== Installing & Enabling Firewall (UFW) ===${NC}"
sudo apt install -y ufw gufw
sudo ufw status | grep -q "Status: active" || { sudo ufw --force enable && sudo systemctl enable --now ufw; }
