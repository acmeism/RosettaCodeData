quibble() {
    printf '{'
    if (( $# > 1 )) printf '%s and ' ${(j:, :)@[1,-2]}
    printf '%s}\n' $@[-1]
}
