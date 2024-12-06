#!/bin/sh

STATUS_FILE="status"

if [ ! -f "$STATUS_FILE" ]; then
    touch "$STATUS_FILE"
fi

if [ "$UID" -eq 0 ]; then
    echo 'This script should not be run as root' >&2
    exit 1
fi

check_status() {
    STEP_NAME=$1
    if grep -q "$STEP_NAME" "$STATUS_FILE"; then
        echo "Skipping $STEP_NAME"
        return 0
    else
        return 1
    fi
}

update_status() {
    STEP_NAME=$1
    echo "$STEP_NAME" >> "$STATUS_FILE"
}

echo "Getting sudo ready"
sudo -v

FONTLIST="nerd-fonts-meslo terminus-font noto-fonts-emoji noto-fonts-cjk ttf-terminus-nerd ttf-hack ttf-liberation"
AUREXTRAS="jumpapp insomnia-bin"

if ! check_status "dotfiles"; then
    MESSAGE="Moving dotfiles to home"
    echo $MESSAGE
    sudo pacman -S --noconfirm rsync || { echo "Failed: $MESSAGE" ; exit 1; }
    cd gotoHome
    rsync -av . ~ || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "Moved to home"
    update_status "dotfiles"
fi

if ! check_status "packages"; then
    MESSAGE="Installing packages"
    echo $MESSAGE
    sudo pacman -Sy || { echo "Failed: $MESSAGE" ; exit 1; }
    sudo pacman -S --needed --noconfirm $(cat packageList) || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "Packages installed"
    update_status "packages"
fi

if ! check_status "yay"; then
    MESSAGE="Installing yay Aur Helper"
    echo $MESSAGE
    rm -rf yay > /dev/null
    git clone https://aur.archlinux.org/yay.git || { echo "Failed: $MESSAGE" ; exit 1; }
    cd yay
    makepkg -si || { echo "Failed: $MESSAGE" ; exit 1; }
    rm -rf yay > /dev/null
    cd ~
    echo "Yay installed"
    update_status "yay"
fi

if ! check_status "fonts"; then
    MESSAGE="Installing fonts via AUR"
    echo $MESSAGE
    yay -Sy || { echo "Failed: $MESSAGE" ; exit 1; }
    yay -S --needed --noconfirm $FONTLIST || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "Installed fonts via AUR"
    update_status "fonts"
fi

if ! check_status "extras"; then
    MESSAGE="Installing extras with yay"
    echo $MESSAGE
    yay -S --needed --noconfirm $AUREXTRAS || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "Installed extra software"
    update_status "extras"
fi

if ! check_status "zsh_plugins"; then
    MESSAGE="Installing zsh plugins"
    echo $MESSAGE
    mkdir -p ~/.zsh/plugins
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions/ || { echo "Failed: $MESSAGE" ; exit 1; }
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ~/.zsh/plugins/fast-syntax-highlighting/ || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "zsh plugins installed"
    update_status "zsh_plugins"
fi

if ! check_status "tmux"; then
    MESSAGE="Setting up tmux"
    echo $MESSAGE
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || { echo "Failed: $MESSAGE" ; exit 1; }
    ~/.tmux/plugins/tpm/bin/install_plugins || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "tmux finally set up"
    update_status "tmux"
fi

if ! check_status "neovim"; then
    MESSAGE="Setting up neovim"
    echo $MESSAGE
    git clone https://github.com/Nilet/nvim ~/.config/nvim || { echo "Failed: $MESSAGE" ; exit 1; }
    git clone --depth 1 https://github.com/wbthomason/packer.nvim\
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim || { echo "Failed: $MESSAGE" ; exit 1; }
    nvim -c ":PackerSync"
    echo "Nvim working as usual"
    update_status "neovim"
fi

if ! check_status "ssh"; then
    MESSAGE="Setting up SSH service"
    echo $MESSAGE
    sudo systemctl enable sshd.service || { echo "Failed: $MESSAGE" ; exit 1; }
    sudo systemctl start sshd.service || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "SSH setup finished"
    update_status "ssh"
fi

if ! check_status "i3currentmedia"; then
    MESSAGE="Installing i3currentmedia"
    echo $MESSAGE
    mkdir -p ~/.local/scripts/
    git clone https://github.com/Nilet/i3currentMedia ~/.local/scripts/i3currentMedia/ || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "i3currentmedia installed"
    update_status "i3currentmedia"
fi

if ! check_status "zsh_default"; then
    MESSAGE="Changing zsh to default"
    echo $MESSAGE
    chsh -s /usr/bin/zsh || { echo "Failed: $MESSAGE" ; exit 1; }
    echo "ZSH is the default shell now"
    update_status "zsh_default"
fi

if ! check_status "user_configs"; then
    sed -i "s/matheus/$(whoami)/g" ~/.config/i3/config
    sed -i "s/matheus/$(whoami)/g" ~/.zshrc
    sed -i "s/matheus/$(whoami)/g" ~/.config/mpv/mpv.conf
    sed -i "s/matheus/$(whoami)/g" ~/.config/mpv/scripts/webm.lua
    update_status "user_configs"
fi

echo "Setup complete"
