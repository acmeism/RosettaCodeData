Rebol [
  title: "Rosetta code: Increment loop index within loop body"
  file: %Increment_loop_index_within_loop_body.r3
  url: https://rosettacode.org/wiki/Increment_loop_index_within_loop_body
  needs: 3.0.0
]

;; prime? native function is available since 3.19.5
if unset? 'prime? [
    ;; Naive Rebol implementation
    prime?: function [n [integer!]] [
        if n < 2 [return false]
        if zero? n % 2 [return n == 2]
        if zero? n % 3 [return n == 3]
        d: 5
        while [d * d <= n][
            if zero? n % d [return false]
            d: d + 2
            if zero? n % d [return false]
            d: d + 4
        ]
        true
    ]
]

;; Helper to format number with commas
format-commas: function [num [integer!]] [
    str: reverse form num
    while [not tail? str: skip str 3][
        str: insert str ","
    ]
    reverse head str
]

;; Main logic
index: 42           ;; start index at 42 (before first increment)
count-primes: 0     ;; count of primes found
while [count-primes < 42] [
    index: index + 1     ;; increment index by 1 at iteration start
    if prime? index [
        count-primes: count-primes + 1
        print rejoin [
            pad count-primes -2
            ": prime = "
            pad format-commas index -18
        ]
        ;; increment index by the prime itself (old index + prime)
        index: index + index
    ] ()
]
