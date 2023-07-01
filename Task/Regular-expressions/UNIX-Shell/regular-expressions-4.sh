if [[ $s =~ $re ]]; then
    submatch=${BASH_REMATCH[0]}
    modified="${s%%$submatch*}$repl${s#*$submatch}"
    echo "$modified"           # I am the modified string
fi
