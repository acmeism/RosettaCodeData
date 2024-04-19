quibble() {
    printf '{'
    while [ $# -gt 2 ]; do
        printf '%s, ' "$1"
        shift
    done
    if [ $# -gt 0 ]; then
        printf '%s' "$1"
        shift
    fi
    if [ $# -gt 0 ]; then
        printf ' and %s' "$1"
    fi
    printf '%s\n' '}'
}
