if status is-interactive
    # show fastfetch and print a empty line after
    fastfetch --pipe --config ff
    echo ''

    # enable starship.rs
    # starship init fish | source

    # enable oh-my-posh
    # oh-my-posh init fish --config '' | source

    # enable fzf shell integration
    fzf --fish | source
end
