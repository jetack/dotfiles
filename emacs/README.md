# Emacs Configuration

Modern Emacs configuration with straight.el package manager.

## Requirements

- Emacs 29+
- basedpyright (Python LSP): `npm install -g basedpyright`
- ruff (Python linter/formatter): `pip install ruff`
- ripgrep (for consult-ripgrep): `apt install ripgrep`

## Installation

```bash
./install.sh
```

This creates symlinks:
- `~/.emacs` -> `dotfiles/emacs/.emacs`
- `~/.emacs.d/early-init.el` -> `dotfiles/emacs/early-init.el`

## First Run

On first startup, straight.el will download and build all packages. This takes a few minutes.

## Files

| File | Description |
|------|-------------|
| `.emacs` | Main configuration |
| `early-init.el` | Early init (disables package.el for straight.el) |
| `install.sh` | Symlink installer |

## Key Packages

| Package | Purpose |
|---------|---------|
| straight.el | Package manager |
| corfu + cape | Completion UI |
| vertico + orderless + consult | Minibuffer completion |
| eglot + basedpyright | Python LSP |
| apheleia + ruff | Python formatting |

## Keybindings

| Key | Command |
|-----|---------|
| `C-s` | Search in buffer (consult-line) |
| `C-x b` | Switch buffer with preview |
| `M-s r` | Ripgrep project search |
| `C-.` | Embark actions |
| `TAB` | Complete selection |
