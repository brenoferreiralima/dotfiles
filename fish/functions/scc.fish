# clean the system caches with yay and pacman
function scc --wraps='yes | yay -Scc' --description 'alias scc=yes | yay -Scc'
    yes | yay -Scc $argv     
end