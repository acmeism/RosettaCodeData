iseven() {
    [[ $(($1%2)) -eq 0 ]] && return 0
    return 1
}
