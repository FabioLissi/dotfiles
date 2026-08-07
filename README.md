# dotfiles

macOS development environment configs: ghostty, neovim (NvChad), fish, tmux, starship, git.

## Setup on a new machine

```fish
git clone https://github.com/FabioLissi/dotfiles.git ~/dotfiles

mkdir -p ~/.config
ln -s ~/dotfiles/ghostty ~/.config/ghostty
ln -s ~/dotfiles/nvim ~/.config/nvim
ln -s ~/dotfiles/fish ~/.config/fish
ln -s ~/dotfiles/tmux ~/.config/tmux
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/git/gitconfig ~/.gitconfig
ln -s ~/dotfiles/git/ignore ~/.config/git/ignore
```

### Dependencies

```fish
brew install fish starship neovim tmux bat exa trash pyenv fzf
```

- **Fonts**: PragmataPro Liga and Symbols Nerd Font Mono (ghostty)
- **fish plugins**: install [fisher](https://github.com/jorgebucaran/fisher), then `fisher update` (reads `fish_plugins`). Note: `~/repos/forge-fish` is a local plugin — clone it first or remove it from `fish_plugins`.
- **tmux plugins**: `git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm`, then prefix + I inside tmux
- **neovim**: plugins install automatically via lazy.nvim on first launch

### Secrets

API keys are not tracked. Create `~/.config/fish/secrets.fish` by hand with any
`set -gx MY_API_KEY "..."` exports; `config.fish` sources it when present.
