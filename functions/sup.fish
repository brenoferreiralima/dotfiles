# update system with yay and flatpak
function sup --wraps='yay && flatpak update' --description 'alias sup=yay && flatpak update'
    yay && flatpak update $argv     
end