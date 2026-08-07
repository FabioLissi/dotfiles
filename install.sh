#!/bin/bash
# Fresh-install bootstrap for a new Mac. Idempotent — safe to re-run any time.
#   curl -fsSL https://raw.githubusercontent.com/FabioLissi/dotfiles/main/install.sh | bash
set -e

DOTFILES="$HOME/dotfiles"
REPO="https://github.com/FabioLissi/dotfiles.git"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$1"; }

step "Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Finish the Command Line Tools installer dialog, then re-run this script."
    exit 1
fi

step "Homebrew"
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

step "Packages"
brew install fish starship neovim tmux bat eza trash pyenv fzf gh
brew install --cask ghostty font-symbols-only-nerd-font

step "Fonts"
if ! find ~/Library/Fonts /Library/Fonts -iname '*pragmata*' 2>/dev/null | grep -q .; then
    warn "PragmataPro Liga not installed (commercial font — copy the .ttf/.otf files to ~/Library/Fonts by hand). Ghostty falls back to Symbols Nerd Font Mono until then."
fi

step "Dotfiles repo"
if [ -d "$DOTFILES/.git" ]; then
    git -C "$DOTFILES" pull --ff-only
else
    git clone "$REPO" "$DOTFILES"
fi

step "Symlinks"
mkdir -p "$HOME/.config/git"
for dir in ghostty nvim fish tmux; do
    target="$HOME/.config/$dir"
    if [ -d "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
        warn "existing ~/.config/$dir was a real directory — moved it to $dir.bak.*"
    fi
    ln -sfn "$DOTFILES/$dir" "$target"
done
ln -sfn "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"
ln -sfn "$DOTFILES/git/gitconfig" "$HOME/.gitconfig"
ln -sfn "$DOTFILES/git/ignore" "$HOME/.config/git/ignore"

step "fish as default shell"
FISH_BIN="$(command -v fish)"
if ! grep -qx "$FISH_BIN" /etc/shells; then
    echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null
fi
CURRENT_SHELL="$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')"
if [ "$CURRENT_SHELL" != "$FISH_BIN" ]; then
    chsh -s "$FISH_BIN"
    echo "Default shell set to fish — new Ghostty windows will use it."
fi

step "fish plugins (fisher)"
fish -c 'type -q fisher; or begin; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher; end'
if [ ! -d "$HOME/repos/forge-fish" ]; then
    warn "~/repos/forge-fish missing (local plugin in fish_plugins) — clone it and re-run, or remove it from fish_plugins"
fi
fish -c 'fisher update' || warn "fisher update reported errors — see above"

step "tmux plugins (tpm)"
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi
"$HOME/.config/tmux/plugins/tpm/bin/install_plugins" || warn "tpm plugin install failed — run prefix + I inside tmux"

step "neovim plugins"
nvim --headless "+Lazy! sync" +qa || warn "lazy.nvim sync failed — plugins will install on first nvim launch"

step "Per-machine files"
if [ ! -f "$HOME/.config/fish/secrets.fish" ]; then
    warn "create ~/.config/fish/secrets.fish for API keys (set -gx MY_API_KEY \"...\")"
fi
if [ ! -f "$HOME/.gitconfig.local" ]; then
    warn "create ~/.gitconfig.local with your git email:  [user]\\n\\temail = you@example.com"
fi

printf '\n\033[1;32mDone.\033[0m Open a new Ghostty window — it will start in fish.\n'
