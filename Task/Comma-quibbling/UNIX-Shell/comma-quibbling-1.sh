quibble() {
    printf '{'
    while (( $# > 2 )); do
        printf '%s, ' "$1"
        shift
    done
    if (( $# )); then
        printf '%s' "$1"
        shift
    fi
    if (( $# )); then
        printf ' and %s' "$1"
    fi
    printf '%s\n' '}'
}
