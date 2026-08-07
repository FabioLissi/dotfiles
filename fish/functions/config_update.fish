function config_update -d "Pull latest dotfiles and reload fish; --full also re-runs install.sh"
    git -C ~/dotfiles pull --ff-only; or return
    if contains -- --full $argv
        bash ~/dotfiles/install.sh
    else
        echo "config updated — new packages/fonts/plugins? run: config_update --full"
    end
    refresh
end
