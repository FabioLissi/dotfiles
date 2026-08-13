if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Setup brew FIRST — everything below depends on /opt/homebrew/bin being on
# PATH, and non-login shells (ssh remote commands) don't get it otherwise
if test -x /opt/homebrew/bin/brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

# Prompt — interactive shells only, and only if starship is actually there
if status is-interactive; and type -q starship
    starship init fish | source
end

# Disable the fish greeting message
set fish_greeting ""

# Print a new line after any command
source ~/.config/fish/functions/postexec_newline.fish

# Clear line on CTRL + C
# Sometimes it still doesn't work well enough on node.js scripts :(
bind --preset \cC 'cancel-commandline'

# Auto-switch nvm version on cd
# Requires a ~/.node-version file with a valid node version
# https://github.com/jorgebucaran/nvm.fish/pull/186
if type -q nvm
  function __nvm_auto --on-variable PWD
  nvm use --silent 2>/dev/null # Comment out the silent flag for debugging
  end
  __nvm_auto
end

# Pyenv setup
# Requires `brew install pyenv`
if type -q pyenv
  status --is-interactive; and source (pyenv init -|psub)
end

# Python 3.14 as system-wide default (via Homebrew python@3.14)
# libexec/bin contains unversioned `python`, `pip`, `pydoc`, `idle`, `wheel` -> 3.14
# (unversioned `python3`/`pip3` come from /opt/homebrew/bin via `brew link python@3.14`)
if test -d /opt/homebrew/opt/python@3.14/libexec/bin
  fish_add_path /opt/homebrew/opt/python@3.14/libexec/bin
end

# `ls` → `ls -laG` abbreviation
abbr -a -g ls ls -laG

# `ls` → `exa` abbreviation
# Requires `brew install exa`
if type -q exa
  abbr --add -g ls 'exa --long --classify --all --header --git --no-user --tree --level 1'
end

# `ls` → `eza` abbreviation (maintained fork of exa; exa is gone from Homebrew)
# Requires `brew install eza`
if type -q eza
  abbr --add -g ls 'eza --long --classify --all --header --git --no-user --tree --level 1'
end

# `cat` → `bat` abbreviation
# Requires `brew install bat`
if type -q bat
  abbr --add -g cat 'bat'
end

# `rm` → `trash` abbreviation (moves files to the trash instead of deleting them)
# Requires `brew install trash`
if type -q trash
  abbr --add -g rm 'trash'
end

# uv
fish_add_path "$HOME/.local/bin"

# Added by Antigravity
fish_add_path $HOME/.antigravity/antigravity/bin

# Obsidian CLI
fish_add_path /Applications/Obsidian.app/Contents/MacOS

# Quick cd aliases
abbr --add -g repos 'cd ~/repos'
abbr --add -g work-repos 'cd ~/work-repos'

function get_idf
      source $HOME/work-repos/esp-idf/export.fish
 end

# Default editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Secrets (API keys etc.) live in an untracked local file — create it by hand:
#   ~/.config/fish/secrets.fish
test -f ~/.config/fish/secrets.fish; and source ~/.config/fish/secrets.fish

set -gx FORGE_EDITOR "vi"
