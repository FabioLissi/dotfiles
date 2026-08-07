function secrets_sync -d "Render ~/.config/fish/secrets.fish from 1Password via op inject"
    if not type -q op
        echo "1Password CLI missing — brew install --cask 1password-cli" >&2
        return 1
    end
    op inject -f -i ~/dotfiles/fish/secrets.fish.tpl -o ~/.config/fish/secrets.fish
    and chmod 600 ~/.config/fish/secrets.fish
    and source ~/.config/fish/secrets.fish
    and echo "secrets.fish rendered from 1Password and loaded"
end
