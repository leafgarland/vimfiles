function fish_prompt
    if test $status -ne 0
        set promptColour red
    else if test "$USER" = 'root'
        set promptColour blue
    else 
        set promptColour green
    end

    # Main
    echo (set_color cyan)(prompt_pwd)

    if test $SSH_TTY
        set userDesc $USER'@'(prompt_hostname)
    else if test "$USER" = 'root'
        set userDesc 'root'
    else
        set userDesc ''
    end

    echo -n (set_color -b $promptColour; set_color brwhite)" $userDesc "(set_color normal; set_color $promptColour)''(set_color normal)' '
end
