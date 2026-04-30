Rebol [
    title: "Rosetta code: Anti-primes"
    file:  %Anti-primes.r3
    url:   https://rosettacode.org/wiki/Anti-primes
    needs: 3.0.0
]
n: found: max_div: 0
print "The first 20 anti-primes are:"
while [++ n][  ;; n := n + 1 each loop; continue until we explicitly halt after 20 found
    nDiv: 1    ;; start divisor count at 1 to include n itself
    ;; For n > 1, count divisors in 1..(n/2); each divisor d (d divides n) adds 1
    if n > 1 [
        repeat div n / 2 [
            if n % div = 0 [++ nDiv]
        ]
    ]
    ;; If current n has more divisors than any smaller number seen, it's an anti-prime
    if nDiv > max_div [
        max_div: nDiv  ;; update the record
        prin [n ""]    ;; print the anti-prime inline (space-separated)
        ++ found       ;; stop after printing the first 20 anti-primes
        if found == 20 [print "" break]
    ]
]
