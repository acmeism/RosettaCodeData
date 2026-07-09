Rebol [
    title: "Rosetta code: The sieve of Sundaram"
    file:  %The_sieve_of_Sundaram.r3
    url:   https://rosettacode.org/wiki/The_sieve_of_Sundaram
]

sieve-of-sundaram: function [
    "Finds primes using the Sieve of Sundaram up to the nth prime"
    nth [integer!] "Which prime to find"
    /verbose       "Print all primes found"
][
    assert [nth > 0  "nth must be a positive integer"]
    k: (2.4 * nth * log-e nth) // 2 ;; nth prime is at about n * log(n)
    composites: make bitset! k      ;; defaults to all false
    for i 1 k - 1 1 [
        j: i
        while [(p: 2 * i * j + i + j) < k] [
            composites/:p: true
            ++ j
        ]
    ]
    pcount: 0
    for i 1 k 1 [
       unless composites/:i [       ;; it's prime
            ++ pcount
            if verbose [
                prin [pad (2 * i + 1) -4 ""]
                if zero? pcount % 10 [print ""]
            ]
            if pcount = nth [
                print rejoin [
                    "^/Sundaram primes start with 3. The " nth
                    "th Sundaram prime is " 2 * i + 1 "."
                ]
                break
            ]
        ]
    ]
]

sieve-of-sundaram/verbose 100
sieve-of-sundaram 1000000
