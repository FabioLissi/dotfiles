# dotfiles

macOS development environment configs: ghostty, neovim (NvChad), fish, tmux, starship, git.

## Setup on a new machine

Paste into zsh (the stock macOS shell) — idempotent, re-run as often as you like:

```sh
curl -fsSL https://raw.githubusercontent.com/FabioLissi/dotfiles/main/install.sh | bash
```

The script installs Homebrew, packages (fish, starship, neovim, tmux, bat, eza,
trash, pyenv, fzf, gh), Ghostty, Symbols Nerd Font Mono, symlinks all configs,
makes fish the default shell (so Ghostty stops opening zsh), and sets up fisher
and tpm plugins. Existing real config directories are moved to `*.bak.*`, never
deleted. Or run it from a clone: `bash ~/dotfiles/install.sh`.

### Manual steps it can't do

- **PragmataPro Liga** is a commercial font — copy the font files into `~/Library/Fonts` yourself (the script warns until you do)
- `~/repos/forge-fish` is a local fish plugin — clone it, or remove it from `fish_plugins`
- The per-machine secrets files below

### Secrets

API keys are not tracked. Create `~/.config/fish/secrets.fish` by hand with any
`set -gx MY_API_KEY "..."` exports; `config.fish` sources it when present.

Git email is per-machine. Create `~/.gitconfig.local` by hand:

```gitconfig
[user]
	email = you@example.com
```
