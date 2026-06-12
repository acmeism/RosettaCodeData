Rebol [
    title: "Rosetta code: Numbers divisible by their individual digits, but not by the product of their digits"
    file:  %Numbers_divisible_by_their_individual_digits,_but_not_by_the_product_of_their_digits.r3
    url:   https://rosettacode.org/wiki/Numbers_divisible_by_their_individual_digits,_but_not_by_the_product_of_their_digits
]

divisible?: function [
    "Check if n is divisible by each of its digits but not by their product"
    n [integer!]
][
    p: 1
    c: n
    while [c > 0][
        d: c % 10                          ;; extract rightmost digit
        if any [d == 0  not zero? n % d][  ;; digit is 0 or doesn't divide n -> fail
            return false
        ]
        p: p * d                           ;; accumulate digit product
        c: to integer! c / 10              ;; shift right one digit
    ]
    not zero? remainder n p                ;; n must NOT be divisible by digit product
]

count: 0
repeat i 999 [
    if divisible? i [
        prin pad i -4                       ;; right-align in 4-char field
        ++ count
        if zero? count % 20 [prin LF]       ;; newline every 20th number
    ]
]

print [
    "^/Numbers divisible by their individual digits but not by the product of their digits 1-999:"
    as-green count
]
