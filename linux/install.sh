#!/bin/sh

if [ $UID -eq 0 ]; then
        echo 'This script should not be run as root' >&2
        exit 1
fi

sudo echo "Getting sudo ready"
installList="zsh btop xorg linux-headers xdg-utils xdg-user-dirs networkmanager alacritty i3status firefox dmenu thunderbird ueberzug python ffmpeg xorg-xinit fzf ripgrep zsh i3-wm picom feh mpv unclutter dunst pasystray scrot playerctl nautilus pavucontrol unrar tldr bat qbittorrent yt-dlp numlockx flac gstreamer mpd pulseaudio xfsprogs openssh python-pip xclip xsel"
fontList="nerd-fonts-meslo terminus-font-td1 noto-fonts-emoji imagemagick"
aurExtras="spotify lf discord-ptb kotatogram-desktop-bin yt-dlp jumpapp"

echo "Moving dotfiles to home"
sudo cp -r gotoHome/.* ~
echo "Moved to home"
echo "Installing packages"
sudo pacman -Sy
sudo pacman -S --needed --noconfirm $installList
echo "Packages installed"

echo "Installing yay Aur Helper"
rm -rf yay > /dev/null
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~
echo "Yay installed"

echo "Installing fonts via AUR"
yay -Sy
yay -S --needed --noconfirm $fontList
echo "Installed fonts via AUR"

echo "Installing extras with yay"
yay -S --needed --noconfirm $aurExtras
echo "Installed extra software"

echo "Installing zsh plugins"
sudo chown -R matheus ~
mkdir ~/.zsh/plugins
cd ~/.zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting
echo "zsh plugins installed"

echo "Setting up SSH service"
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
echo "SSH setup finished"

echo "Installing i3currentmedia"
cd ~/.local/scripts/
git clone https://github.com/Nilet/i3currentMedia
echo "i3currentmedia installed"

echo "Changing zsh to default shell"
chsh -s /usr/bin/zsh
echo "ZSH as default shell now"
