Rebol [
   title: "Rosetta code: Piprimes"
   file:  %Piprimes.r3
   url:   https://rosettacode.org/wiki/Piprimes
]

pi-primes: function [
    "Returns the sequence of running prime counts up to (but not including) the nth prime"
    limit [integer!] "number of primes at which to stop"
][
    curr: running: 0                  ;; current number being tested, count of primes found
    out: copy []                      ;; accumulates running prime-count at each step

    while [true] [
        ++ curr                       ;; advance to next candidate
        if prime? curr [ ++ running ] ;; bump count if candidate is prime
        if running = limit [ break ]  ;; stop when we've hit the target prime count
        append out running            ;; record current count before next iteration
    ]
    out                               ;; return the sequence
]

counts: pi-primes 22
forall counts [
    prin pad counts/1 -3
    if zero? mod index? counts 10 [print ""]
]
print rejoin [LF "Pi-Primes 0-21: " as-green length? counts]
