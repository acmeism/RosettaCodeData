typeset -i boundedint
function boundedint.set {
    nameref var=${.sh.name}
    if (( 1 <= .sh.value && .sh.value <= 10 )); then
        # stash the valid value as a backup, in case we need to restore it
        typeset -i var.previous_value=${.sh.value}
    else
        print -u2 "value out of bounds"
        # restore previous value
        .sh.value=${var.previous_value}
    fi
}

boundedint=-5; echo $boundedint
boundedint=5;  echo $boundedint
boundedint=15; echo $boundedint
