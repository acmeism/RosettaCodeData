#! /bin/bash
pascal() {
    local -i n=${1:-1}
    if (( n <= 1 )); then
        echo 1
    else
        local output=$( $FUNCNAME $((n - 1)) )
        set -- $( tail -n 1 <<<"$output" )   # previous row
        echo "$output"
        printf "1 "
        while [[ -n $1 ]]; do
            printf "%d " $(( $1 + ${2:-0} ))
            shift
        done
        echo
    fi
}
pascal "$1"
