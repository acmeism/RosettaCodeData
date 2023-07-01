if [[ $BASH_VERSION < "4.2" ]]; then
    echo "version is too old"
    exit
fi

if [[ ! -v bloop ]]; then
    echo "no bloop variable"
elif [[ $(type -t abs 2>/dev/null) != function ]]; then
    echo "abs is not a shell function"
else
    echo $(abs $bloop)
fi

# need to populate the variables and use them within the same subshell in a pipeline.
set | {
    shopt -s extglob
    int_vars=()
    while IFS='=' read -r var value; do
        if [[ $value == +([[:digit:]]) ]]; then
            int_vars+=($var)
            (( sum += value ))
        fi
    done
    echo "${int_vars[*]}"
    echo $sum
}
