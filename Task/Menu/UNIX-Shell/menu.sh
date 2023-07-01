# choose 'choice 1' 'choice 2' ...
#   Prints menu to standard error. Prompts with PS3.
#   Reads REPLY from standard input. Sets CHOICE.
choose() {
    CHOICE=                     # Default CHOICE is empty string.
    [[ $# -gt 0 ]] || return    # Return if "$@" is empty.
    select CHOICE; do           # Select from "$@".
        if [[ -n $CHOICE ]]; then
            break
        else
            echo Invalid choice.
        fi
    done
}

PS3='Which is from the three pigs: '
choose 'fee fie' 'huff and puff' 'mirror mirror' 'tick tock'
[[ -n $CHOICE ]] && echo You chose: $CHOICE
[[ -z $CHOICE ]] && echo No input.
