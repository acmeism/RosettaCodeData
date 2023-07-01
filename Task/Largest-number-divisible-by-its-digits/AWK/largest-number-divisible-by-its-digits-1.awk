# Usage: gawk -f LARGEST_NUMBER_DIVISIBLE_BY_ITS_DIGITS_10.AWK
BEGIN {
    base = 10
    comdiv = 12
    startn = 9876543
    stopn = 1000000
    solve(startn, stopn)
}
function solve(startn, stopn,    n, d) {
    for (n = startn - startn % comdiv; n > stopn; n -= comdiv) {
        if (hasuniqedigits(n)) {
            # Check divisibility of n by all its digits
            for (d = 2; d < base; d++) {
                if ((dcount[d]) && (n % d)) {
                    break
                }
            }
            if (d == base) {
                printf("%d\n", n)
                return
            }
        }
    }
}
function hasuniqedigits(n,    d) {
    # Returns 1, if n consists of unique digits in range 1..(base-1)
    # The array dcount stores the count (up to 1) of those digits
    for (d = 1; d < base; d++)
        dcount[d] = 0
    while (n) {
        d = n % base
        if ((d == 0) || (++dcount[d] > 1))
            return 0
        n = int(n / base)
    }
    return 1
}
