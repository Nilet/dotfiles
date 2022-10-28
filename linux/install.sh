#!/bin/sh

if [ $UID -eq 0 ]; then
        echo 'This script should not be run as root' >&2
        exit 1
fi

sudo echo "Getting sudo ready"
installList="zsh alacritty firefox thunderbird ueberzug python ffmpeg xorg-xinit fzf ripgrep zsh i3-wm picom feh mpv jumpapp unclutter dunst pasystray scrot playerctl dolphin pavucontrol unrar tldr bat qbittorrent yt-dlp numlockx flac gstreamer mpd pulseaudio xfsprogs openssh"
fontList="ttf-meslo-nerd-font-powerlevel10k terminus-font-td1-otb"
aurExtras="spotify lf discord-ptb kotatogram-desktop-bin yt-dlp"

echo "Moving dotfiles to home"
sudo cp -r gotoHome/.* temp
echo "Moved to home"
echo "Installing packages"
sudo pacman -Sy
sudo pacman -S --needed $installList
echo"Packages installed"

echo "Installing yay Aur Helper"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
echo "Yay installed"

echo "Installing fonts via AUR"
yay -Sy
yay -S --aur $fontList
echo "Installed fonts via AUR"

echo "Installing extras with yay"
yay -S --aur $aurExtras
echo "Installed extra software"

echo "Setting up SSH service"
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
echo "SSH setup finished"
