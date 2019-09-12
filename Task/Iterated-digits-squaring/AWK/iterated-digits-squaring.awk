# Usage: GAWK -f ITERATED_DIGITS_SQUARING.AWK
BEGIN {
    # Setup buffer for results up to 9*9*8
    for (i = 1; i <= 648; i++) {
        k = i
        do {
            k = squaredigitsum(k)
        } while ((k != 1) && (k != 89))
        if (k == 1) # This will give us 90 entries
            buffer[i] = ""
    }
    # Check sequence for every number
    pow10 = 1
    for (i = 1; i <= 100000000; i++) {
        count += (squaredigitsum(i) in buffer) ? 0 : 1
        if (i == pow10) {
            printf("1->10^%d: %d\n", length(i) - 1, count)
            pow10 *= 10
        }
    }
}
function squaredigitsum(n,    r) {
    while (n) {
        r += (n % 10) ^ 2
        n = int(n / 10)
    }
    return r
}
