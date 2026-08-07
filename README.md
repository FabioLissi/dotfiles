# dotfiles

macOS development environment configs: ghostty, neovim (NvChad), fish, tmux, starship, git.

## Setup on a new machine

Paste into zsh (the stock macOS shell — works before fish is installed):

```sh
if [ -d ~/dotfiles/.git ]; then
    git -C ~/dotfiles pull
else
    git clone https://github.com/FabioLissi/dotfiles.git ~/dotfiles
fi

mkdir -p ~/.config/git
ln -sfn ~/dotfiles/ghostty ~/.config/ghostty
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/fish ~/.config/fish
ln -sfn ~/dotfiles/tmux ~/.config/tmux
ln -sfn ~/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -sfn ~/dotfiles/git/gitconfig ~/.gitconfig
ln -sfn ~/dotfiles/git/ignore ~/.config/git/ignore
```

Re-runnable: `-sfn` replaces existing files and symlinks. Caveat: if one of the
`~/.config` targets already exists as a real directory (not a symlink), move it
aside first, e.g. `mv ~/.config/nvim ~/.config/nvim.bak`.

### Dependencies

```sh
brew install fish starship neovim tmux bat exa trash pyenv fzf
```

- **Fonts**: PragmataPro Liga and Symbols Nerd Font Mono (ghostty)
- **fish plugins**: install [fisher](https://github.com/jorgebucaran/fisher), then `fisher update` (reads `fish_plugins`). Note: `~/repos/forge-fish` is a local plugin — clone it first or remove it from `fish_plugins`.
- **tmux plugins**: `git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm`, then prefix + I inside tmux
- **neovim**: plugins install automatically via lazy.nvim on first launch

### Secrets

API keys are not tracked. Create `~/.config/fish/secrets.fish` by hand with any
`set -gx MY_API_KEY "..."` exports; `config.fish` sources it when present.

Git email is per-machine. Create `~/.gitconfig.local` by hand:

```gitconfig
[user]
	email = you@example.com
```
