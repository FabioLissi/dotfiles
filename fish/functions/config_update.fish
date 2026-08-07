function config_update -d "Pull latest dotfiles; --full also re-runs install.sh"
    git -C ~/dotfiles pull --ff-only
    if contains -- --full $argv
        bash ~/dotfiles/install.sh
    else
        echo "config updated — new packages/fonts/plugins? run: config_update --full"
    end
end
