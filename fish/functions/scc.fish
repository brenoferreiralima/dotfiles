# clean the system caches with yay and pacman
function scc --wraps='yes | yay -Scc && flatpak uninstall --unused' --description 'alias scc=yes | yay -Scc && flatpak uninstall --unused'
    yes | yay -Scc && flatpak uninstall --unused $argv     
end
