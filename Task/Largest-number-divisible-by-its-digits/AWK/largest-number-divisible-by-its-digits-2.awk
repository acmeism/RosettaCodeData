# Usage: GAWK -f LARGEST_NUMBER_DIVISIBLE_BY_ITS_DIGITS_16.AWK
BEGIN {
    base = 16
    size = 15
    # startn = FEDCB A9876 54321 (hex)
    for (i = 1; i <= size; i++) {
        startn[i] = i
    }
    comdiv = 360360 # lcm(1..15)
    solve(startn)
}
function solve(n,    r, i) {
    r = hexmod(n, comdiv)
    hexsub(n, r)
    while (n[size] > 0) {
        if (hasuniqedigits(n)) {
            for (i = size; i > 0; i--)
                printf("%0x", n[i])
            printf("\n")
            return
        }
        hexsub(n, comdiv)
    }
}
function hasuniqedigits(n,    d, i) {
    # Return 1, if n is an array of unique digits in range 1..(base-1)
    # The array dcount stores the count (up to 1) of those digits
    for (d = 1; d < base; d++)
        dcount[d] = 0
    for (i = 1; i <= size; i++) {
        d = n[i]
        if ((d == 0) || (++dcount[d] > 1))
            return 0
    }
    return 1
}
function hexmod(n, k,    i, r) {
    # Return n mod k, where n is an array and k is a number
    for (i = size; i > 0; i--) {
        r = (r * base + n[i]) % k
    }
    return r
}
function hexsub(n, m) {
    # Calculate n = n - m, where n is an array and m is a number
    for (i = 1; m && (i <= size); i++) {
        n[i] -= m % base
        m = int(m / base)
        if (n[i] < 0) {
            n[i] += base
            m++
        }
    }
}
