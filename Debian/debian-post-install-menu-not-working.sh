#!/bin/bash
# Debian 13 Cinnamon Post-Install Script with Menu
# Run: bash debian13_setup.sh

GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

function update_system() {
    echo -e "${GREEN}=== Updating System ===${NC}"
    sudo apt update && sudo apt full-upgrade -y
    sudo apt autoremove --purge -y
}

function enable_nonfree() {
    echo -e "${GREEN}=== Enabling Non-Free Firmware ===${NC}"
    sudo sed -i 's/main$/main contrib non-free-firmware/' /etc/apt/sources.list
    sudo sed -i 's/main contrib$/main contrib non-free-firmware/' /etc/apt/sources.list
    sudo apt update
}

function install_firmware() {
    echo -e "${GREEN}=== Installing General Firmware ===${NC}"
    sudo apt install -y firmware-linux firmware-linux-nonfree firmware-misc-nonfree dkms linux-headers-$(uname -r) intel-microcode amd64-microcode
}

function install_intel_drivers() {
    echo -e "${GREEN}=== Installing Intel Graphics Drivers ===${NC}"
    sudo apt install -y xserver-xorg-video-intel mesa-utils libva-intel-driver intel-media-va-driver vainfo
}

function install_amd_drivers() {
    echo -e "${GREEN}=== Installing AMD Graphics Drivers ===${NC}"
    sudo apt install -y xserver-xorg-video-amdgpu mesa-vulkan-drivers mesa-utils vainfo firmware-amd-graphics
}

function install_essentials() {
    echo -e "${GREEN}=== Installing Essentials ===${NC}"
    sudo apt install -y curl wget git build-essential gnome-software synaptic gdebi gparted gnome-disk-utility apt-xapian-index policykit-1-gnome libfuse2 libreoffice libreoffice-impress libreoffice-writer libreoffice-calc celluloid rhythmbox
}

function install_codecs() {
    echo -e "${GREEN}=== Installing Multimedia Codecs ===${NC}"
    sudo apt install -y vlc ffmpeg libavcodec-extra
}

function install_themes() {
    echo -e "${GREEN}=== Installing Cinnamon Themes ===${NC}"
    sudo apt install -y mint-themes mint-y-icons
}

function install_fonts() {
    echo -e "${GREEN}=== Installing Fonts ===${NC}"
    sudo apt install -y fonts-noto fonts-noto-color-emoji fonts-noto-extra fonts-noto-unhinted    
    sudo cd /tmp;wget --no-check-certificate https://github.com/r-not/unibnfonts/archive/master.tar.gz -O ubf.tar.gz;sudo tar -xvf ubf.tar.gz -C /usr/share/fonts/;rm ubf.tar.gz
    cd /tmp;wget --no-check-certificate https://raw.githubusercontent.com/r-not/MyLinuxConfFiles/refs/heads/master/Common-Configs/bn-font-set.sh -O bn-font-set.sh;sh ./bn-font-set.sh
}

function install_browsers() {
    echo -e "${GREEN}=== Installing Browsers ===${NC}"
    sudo apt install -y firefox chromium
    curl -fsS https://dl.brave.com/install.sh | sh
}

function install_power_tools() {
    echo -e "${GREEN}=== Installing Power Management Tools ===${NC}"
    sudo apt install -y tlp tlp-rdw
    sudo systemctl enable tlp
}

function install_timeshift() {
    echo -e "${GREEN}=== Installing Timeshift (Backup Tool) ===${NC}"
    sudo apt install -y timeshift
}

function enable_flatpak() {
    echo -e "${GREEN}=== Enabling Flatpak ===${NC}"
    sudo apt install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

function install_firewall() {
    echo -e "${GREEN}=== Installing & Enabling Firewall (UFW) ===${NC}"
    sudo apt install -y ufw gufw
    sudo ufw enable
    sudo systemctl enable ufw
}

# Menu
while true; do
    echo -e "\n${YELLOW}===== Debian 13 Cinnamon Post-Install Menu =====${NC}"
    echo "1) Update System"
    echo "2) Enable Non-Free Firmware"
    echo "3) Install General Firmware"
    echo "4) Install Intel Graphics Drivers"
    echo "5) Install AMD Graphics Drivers"
    echo "6) Install Essentials"
    echo "7) Install Multimedia Codecs"
    echo "8) Install Cinnamon Themes"
    echo "9) Install Fonts"
    echo "10) Install Browsers"
    echo "11) Install Power Management Tools"
    echo "12) Install Timeshift"
    echo "13) Enable Flatpak"
    echo "14) Install & Enable Firewall"
    echo "15) Run ALL"
    echo "0) Exit"
    read -p "Choose an option: " choice

    case $choice in
        1) update_system ;;
        2) enable_nonfree ;;
        3) install_firmware ;;
        4) install_intel_drivers ;;
        5) install_amd_drivers ;;
        6) install_essentials ;;
        7) install_codecs ;;
        8) install_themes ;;
        9) install_fonts ;;
        10) install_browsers ;;
        11) install_power_tools ;;
        12) install_timeshift ;;
        13) enable_flatpak ;;
        14) install_firewall ;;
        15) update_system; enable_nonfree; install_firmware; install_intel_drivers; install_amd_drivers; install_essentials; install_codecs; install_themes; install_fonts; install_browsers; install_power_tools; install_timeshift; enable_flatpak; install_firewall ;;
        0) echo -e "${GREEN}Exiting...${NC}"; break ;;
        *) echo -e "${YELLOW}Invalid option, try again!${NC}" ;;
    esac
done
