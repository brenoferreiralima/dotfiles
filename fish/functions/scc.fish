function scc --wraps='sudo dnf autoremove && sudo dnf clean all && flatpak uninstall --unused' --description 'alias scc=sudo dnf autoremove && sudo dnf clean all && flatpak uninstall --unused'
    sudo dnf autoremove && sudo dnf clean all && flatpak uninstall --unused $argv
end
