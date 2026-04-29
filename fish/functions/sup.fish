function sup --wraps='sudo dnf upgrade && flatpak update' --description 'alias sup=sudo dnf upgrade && flatpak update'
    sudo dnf upgrade && flatpak update $argv
end
