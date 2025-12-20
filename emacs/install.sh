#!/bin/bash
# Emacs dotfiles installer
# Creates symlinks for .emacs and early-init.el

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Emacs configuration..."

# Symlink .emacs to home directory
if [ -e ~/.emacs ] || [ -L ~/.emacs ]; then
    echo "Backing up existing ~/.emacs to ~/.emacs.backup"
    mv ~/.emacs ~/.emacs.backup
fi
ln -sf "$SCRIPT_DIR/.emacs" ~/.emacs
echo "Linked: ~/.emacs -> $SCRIPT_DIR/.emacs"

# Create ~/.emacs.d if it doesn't exist
mkdir -p ~/.emacs.d

# Symlink early-init.el to ~/.emacs.d/
if [ -e ~/.emacs.d/early-init.el ] || [ -L ~/.emacs.d/early-init.el ]; then
    echo "Backing up existing ~/.emacs.d/early-init.el"
    mv ~/.emacs.d/early-init.el ~/.emacs.d/early-init.el.backup
fi
ln -sf "$SCRIPT_DIR/early-init.el" ~/.emacs.d/early-init.el
echo "Linked: ~/.emacs.d/early-init.el -> $SCRIPT_DIR/early-init.el"

echo ""
echo "Done! Run 'emacs' to start with new configuration."
echo "First startup will download packages via straight.el."
