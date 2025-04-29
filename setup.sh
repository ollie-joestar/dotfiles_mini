#!/bin/bash

# Clone the dotfiles repository
git clone https://github.com/ollie-joestar/dotfiles_mini.git "$HOME/dotfiles_mini"
cd $HOME/dotfiles_mini

export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$XDG_CONFIG_HOME"

# Install Homebrew
if ! command -v brew &> /dev/null; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >> "$HOME/.bashrc"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
    source "$HOME/.bashrc"
fi

# Install Homebrew packages
packages=(
	node
	neovim
)

for package in "${packages[@]}"; do
    brew install "$package"
done

# Create symlinks for existing configuration files
ln -sf "$PWD/.vimrc" "$HOME/.vimrc"
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$PWD/.tmux" "$HOME/.tmux"
ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/.bashrc" "$HOME/.bashrc"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

# Backup and clone nvim configuration
if [ -d "$XDG_CONFIG_HOME/nvim" ]; then
    cp -r "$XDG_CONFIG_HOME/nvim" "$XDG_CONFIG_HOME/backup_nvim"
    rm -rf "$XDG_CONFIG_HOME/nvim"
fi
git clone https://github.com/ollie-joestar/nvim.git "$XDG_CONFIG_HOME/nvim"

# Install tmux plugins
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    "$HOME"/.tmux/plugins/tpm/scripts/install_plugins.sh
else
    echo "Warning: TPM not found. Skipping tmux plugin installation."
fi

# Message to indicate completion
echo "Setup complete. Configuration files have been symlinked and packages installed."
exec zsh
