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

- Nothing font-related anymore — IosevkaTerm Nerd Font installs via Homebrew
- `~/repos/forge-fish` is a local fish plugin — clone it, or remove it from `fish_plugins`
- The per-machine secrets files below

### Full personal app set

`install.sh` installs only the dev core. For everything else (Blender, KiCad,
VS Code extensions, …) there's a `Brewfile` snapshot of the personal machine:

```sh
bash ~/dotfiles/install.sh --apps        # or: brew bundle install --file=~/dotfiles/Brewfile
```

### Secrets (1Password)

API keys are not tracked. `config.fish` sources `~/.config/fish/secrets.fish`
when present. Preferred flow: keep secrets in 1Password, then render the file
from the committed template (`fish/secrets.fish.tpl`, no secrets in it):

```fish
secrets_sync
```

Requires the 1Password CLI (in the Brewfile) with app integration enabled
(1Password → Settings → Developer → Integrate with CLI), and vault items named
as in the template. Fallback: write `secrets.fish` by hand with
`set -gx MY_API_KEY "..."` lines.

### SSH via 1Password (optional)

Store SSH keys in 1Password instead of key files — nothing to migrate between
machines. Enable 1Password → Settings → Developer → Use SSH agent, import your
key as an SSH Key item, then:

```sh
ln -sfn ~/dotfiles/ssh/config ~/.ssh/config
```

This is not part of install.sh on purpose: only link it after the agent toggle
is on, or ssh will try a socket that isn't there.

Git email is per-machine. Create `~/.gitconfig.local` by hand:

```gitconfig
[user]
	email = you@example.com
```
