Rebol [
    title: "Rosetta code: Abundant odd numbers"
    file:  %Abundant_odd_numbers.r3
    url:   https://rosettacode.org/wiki/Abundant_odd_numbers
    needs: 3.20.0 ;; because of the `prime?` native used
    ;@@ https://github.com/Oldes/Rebol3/discussions/140
]

sum-proper-divisors: function[
    "Compute the sum of proper divisors of n"
    n [number!]
][
    db: clear []  ;; List to store divisors
    ;; Iterate divisors up to sqrt(n)
    for div 1 to integer! square-root n 1 [
        if zero? n % div [     ;; If div divides n exactly
            append db div      ;; Add the divisor
            append db n / div  ;; Add the paired divisor
        ]
    ]
    ;; Sum unique divisors and exclude the number itself
    (sum unique db) - n
]

billion: 1'000'000'000         ;; One billion constant
n: ix: 1                       ;; Initialize current number and index

print "The first 25 abundant odd numbers:"

forever [
    n: n + 2                         ;; Move to the next odd number
    if prime? n [continue]           ;; Skip primes (never abundant)
    prop-div: sum-proper-divisors n  ;; Calculate proper divisor sum
    if prop-div <= n [continue]      ;; Not abundant if sum ≤ n

    ;; Handle reporting for milestones and early results
    case [
        ix <= 25 [
            print [pad n -5 ":" prop-div]  ;; List first 25 found
        ]
        ix = 1000 [
            print ["1000th abundant odd number:" n ":" prop-div]
            n: billion + 1                 ;; Skip ahead
        ]
        n > billion [
            print ["First abundant odd number > 1'000'000'000:" n ":" prop-div]
            break                          ;; Exit after this milestone
        ]
    ]
    ++ ix  ;; Increment index of abundant odd numbers found
]
