# Usage: GAWK -f MAGIC_SQUARES_OF_DOUBLY_EVEN_ORDER.AWK
BEGIN {
    n = 8
    msquare[0, 0] = 0
    if (magicsquaredoublyeven(msquare, n)) {
        for (i = 0; i < n; i++) {
            for (j = 0; j < n; j++) {
                printf("%2d ", msquare[i, j])
            }
            printf("\n")
        }
        printf("\nMagic constant: %d\n", (n * n + 1) * n / 2)
        exit 1
    } else {
        exit 0
    }
}
function magicsquaredoublyeven(msquare, n,    size, mult, r, c, i) {
    if (n < 4 || n % 4 != 0) {
        printf("Base must be a positive multiple of 4.\n")
        return 0
    }
    size = n * n
    mult = n / 4 # how many multiples of 4

    i = 0
    for (r = 0; r < n; r++) {
        for (c = 0; c < n; c++) {
            msquare[r, c] = countup(r, c, mult) ? i + 1 : size - i
            i++
        }
    }
    return 1
}
function countup(r, c, mult,    pattern, bitpos) {
    # Returns 1, if we are in a count-up zone (0 otherwise)
    pattern = "1001011001101001"
    bitpos =  int(c / mult) + int(r / mult) * 4 + 1
    return substr(pattern, bitpos, 1) + 0
}
