#!/bin/bash
# Fresh-install bootstrap for a new Mac. Idempotent — safe to re-run any time.
#   curl -fsSL https://raw.githubusercontent.com/FabioLissi/dotfiles/main/install.sh | bash
set -e

DOTFILES="$HOME/dotfiles"
REPO="https://github.com/FabioLissi/dotfiles.git"

# --apps: also install the full personal app set from the Brewfile
INSTALL_APPS=0
for arg in "$@"; do
    [ "$arg" = "--apps" ] && INSTALL_APPS=1
done

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
brew install fish starship neovim tmux bat eza trash pyenv fzf gh ripgrep fd node
brew install --cask ghostty font-iosevka-term-nerd-font font-jetbrains-mono-nerd-font font-symbols-only-nerd-font

step "Dotfiles repo"
if [ -d "$DOTFILES/.git" ]; then
    git -C "$DOTFILES" pull --ff-only
elif [ -d "$DOTFILES" ]; then
    # dir already exists (e.g. untracked per-machine files staged before clone)
    git -C "$DOTFILES" init -b main
    git -C "$DOTFILES" remote add origin "$REPO"
    git -C "$DOTFILES" fetch origin
    git -C "$DOTFILES" checkout -t origin/main
else
    git clone "$REPO" "$DOTFILES"
fi

if [ "$INSTALL_APPS" = 1 ]; then
    step "Full app set (Brewfile)"
    brew bundle install --file="$DOTFILES/Brewfile" || warn "brew bundle had failures — re-run 'brew bundle install --file=~/dotfiles/Brewfile' to retry"
    # untracked private app inventory, if this machine has one
    if [ -f "$DOTFILES/Brewfile.local" ]; then
        step "Local app set (Brewfile.local)"
        brew bundle install --file="$DOTFILES/Brewfile.local" || warn "Brewfile.local had failures (mas apps need App Store sign-in) — re-run to retry"
    fi
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
    # < /dev/tty so the password prompt works when piped via curl | bash
    if chsh -s "$FISH_BIN" < /dev/tty; then
        echo "Default shell set to fish — fully quit Ghostty (Cmd+Q) and reopen."
    else
        warn "chsh failed — run manually: chsh -s $FISH_BIN"
    fi
else
    echo "fish is already the default shell"
fi

step "fish plugins (fisher)"
fish -c 'type -q fisher; or begin; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; and fisher install jorgebucaran/fisher; end'
fish -c 'fisher update' || warn "fisher update reported errors — see above"

step "tmux plugins (tpm)"
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi
"$HOME/.config/tmux/plugins/tpm/bin/install_plugins" || warn "tpm plugin install failed — run prefix + I inside tmux"

step "neovim plugins"
# restore (not sync): install the exact commits from lazy-lock.json
nvim --headless "+Lazy! restore" +qa || warn "lazy.nvim restore failed — run :Lazy restore inside nvim"

step "Per-machine files"
if [ ! -f "$HOME/.config/fish/secrets.fish" ]; then
    warn "create ~/.config/fish/secrets.fish for API keys (set -gx MY_API_KEY \"...\")"
fi
if [ ! -f "$HOME/.gitconfig.local" ]; then
    # < /dev/tty so the prompt works when piped via curl | bash
    printf 'git email for this machine (blank to skip): '
    read -r GIT_EMAIL < /dev/tty || GIT_EMAIL=""
    if [ -n "$GIT_EMAIL" ]; then
        printf '[user]\n\temail = %s\n' "$GIT_EMAIL" > "$HOME/.gitconfig.local"
        echo "wrote ~/.gitconfig.local"
    else
        warn "skipped — create ~/.gitconfig.local with your git email:  [user]\\n\\temail = you@example.com"
    fi
fi

printf '\n\033[1;32mDone.\033[0m Open a new Ghostty window — it will start in fish.\n'
