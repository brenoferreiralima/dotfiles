if status is-interactive
    # Commands to run in interactive sessions can go here
end


# Disable greeting message
set fish_greeting

# Enable starship.rs
starship init fish | source
