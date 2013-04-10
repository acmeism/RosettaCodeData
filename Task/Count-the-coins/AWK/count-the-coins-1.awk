#!/usr/bin/awk -f

BEGIN {
    print cc(100)
    exit
}

function cc(amount, coins,    numPennies, numNickles, numQuarters, p, n, d, q, s, count) {
    numPennies = amount
    numNickles = int(amount / 5)
    numDimes = int(amount / 10)
    numQuarters = int(amount / 25)

    count = 0
    for (p = 0; p <= numPennies; p++) {
        for (n = 0; n <= numNickles; n++) {
            for (d = 0; d <= numDimes; d++) {
                for (q = 0; q <= numQuarters; q++) {
                    s = p + n * 5 + d * 10 + q * 25;
                    if (s == 100) count++;
                }
            }
        }
    }
    return count;
}
