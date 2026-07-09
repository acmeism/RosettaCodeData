Rebol [
    title: "Rosetta code: Summation of primes"
    file:  %Summation_of_primes.r3
    url:   https://rosettacode.org/wiki/Summation_of_primes
]

sum-of-primes: 2       ;; start with the only even prime
for i 3 2'000'000 2 [  ;; odd numbers only
    if prime? i [
        sum-of-primes: sum-of-primes + i
    ]
]
print ["The sum of all primes below 2 million is" as-green sum-of-primes]
