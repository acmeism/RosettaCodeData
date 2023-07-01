bin() {
    set -- "${1:-0}" ""
    while [ 1 -lt "$1" ]
    do
        set -- $(($1 >> 1)) $(($1 & 1))$2
    done
    echo "$1$2"
}

echo $(for i in 0 1 2 5 50 9000; do bin $i; done)
