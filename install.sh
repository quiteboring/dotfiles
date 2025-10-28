#!/bin/bash

# Create directories if they don't exist
mkdir -p ~/.config
mkdir -p ~/wallpapers

echo -e "\033[1;94mRefresh the package database...\033[0m"
sudo pacman -Syu --noconfirm > /dev/null 2>&1

# Copy dotfiles to .config with force flag to override existing files
cp -rf ./dotfiles/fastfetch ~/.config/
cp -rf ./dotfiles/hypr ~/.config/
cp -rf ./dotfiles/kitty ~/.config/
cp -rf ./dotfiles/rofi ~/.config/
cp -rf ./dotfiles/waybar ~/.config/
cp -rf ./dotfiles/xdg-desktop-portal ~/.config/

# Install font
echo -e "\033[1;94mInstalling JetBrains Mono Nerd Font...\033[0m"
sudo pacman -S --noconfirm --needed ttf-jetbrains-mono-nerd xdg-desktop-portal-gtk xdg-desktop-portal-hyprland > /dev/null 2>&1

# Install setup for dark theme (still requires manual input)
echo -e "\033[1;94mInstalling packages for dark mode...\033[0m"
sudo pacman -S --noconfirm --needed xdg-desktop-portal-gtk xdg-desktop-portal-hyprland adw-gtk-theme qt5ct qt6ct kvantum kvantum breeze-icons > /dev/null 2>&1

# Install SDDM

echo -e "\033[1;94mInstalling SDDM\033[0m"
sudo pacman -S --noconfirm --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg > /dev/null 2>&1
sudo systemctl enable sddm > /dev/null 2>&1

echo -e "\033[1;94mCloning SDDM theme repo\033[0m"
git clone https://github.com/uiriansan/SilentSDDM  > /dev/null 2>&1
cd SilentSDDM/
sudo mkdir -p /usr/share/sddm/themes/silent
sudo cp -rf . /usr/share/sddm/themes/silent/
sudo cp -rf ../sddm/sddm.conf /etc/sddm.conf

# Copy wallpaper
echo -e "\033[1;94mCopying wallpaper\033[0m"
cp -f ../images/wallpaper.png ~/wallpapers/wallpaper.png
sudo cp -rf ../images/wallpaper.jpg /usr/share/sddm/themes/silent/backgrounds/default.jpg
sudo cp -rf ../images/wallpaper.jpg /usr/share/sddm/themes/silent/backgrounds/smoky.jpg

echo -e "\033[1;94mSetup avatar image for user\033[0m"

# Get username from user input
echo -e -n "\033[1;93mEnter your username: \033[0m"
read USERNAME


if [[ -f "/usr/share/sddm/faces/$USERNAME.face.icon" ]]; then
    sudo cp -f "/usr/share/sddm/faces/$USERNAME.face.icon" "/usr/share/sddm/faces/$USERNAME.face.icon.bkp"
fi

sudo cp "../images/avatar.jpg" "/usr/share/sddm/faces/tmp_face"
sudo mogrify -gravity center -crop 1:1 +repage "/usr/share/sddm/faces/tmp_face"
sudo mogrify -resize 256x256 "/usr/share/sddm/faces/tmp_face"
sudo mv "/usr/share/sddm/faces/tmp_face" "/usr/share/sddm/faces/$USERNAME.face.icon"

echo -e "\033[1;92mDotfiles installed successfully!\033[0m"