Rebol [
    title: "Rosetta code: Numbers divisible by their individual digits, but not by the product of their digits"
    file:  %Numbers_divisible_by_their_individual_digits,_but_not_by_the_product_of_their_digits.r3
    url:   https://rosettacode.org/wiki/Numbers_divisible_by_their_individual_digits,_but_not_by_the_product_of_their_digits
]

digits-of: function [
    "Extract individual digits of an integer as a block of integers"
    int [integer!]
][
    digs: copy []
    foreach ch to string! int [append digs ch - #"0"]
    digs
]

factors-of: function [
    "Return all factors (divisors) of n as a block"
    int [integer!]
][
    facts: copy []
    repeat i int [if zero? int // i [append facts i]]
    facts
]

product-of: function [
    "Multiply all values in a block together"
    block [any-block!]
][
    result: 1
    foreach x block [result: result * x]
    result
]

all-in?: func [items [block!] pool [block!]][
    ;; exclude removes items not in pool; empty? confirms all matched
    empty? exclude items pool
]

valid?: function [
    "A number is valid if each digit divides n, but the product of digits does not"
    n [integer!]
][
    digs:  digits-of n
    facts: factors-of n
    all [
        not find facts product-of digs  ;; product of digits must NOT be a factor
        all-in? digs facts              ;; every individual digit MUST be a factor
    ]
]

;; Iterate 1–999, printing valid numbers in columns of 20
count: 0
repeat i 999 [
    if valid? i [
        prin pad i -4                   ;; right-align each number in a 4-char field
        ++ count                        ;; increment valid-number counter
        if zero? count % 20 [prin LF]   ;; newline after every 20th number
    ]
]
print [
    "^/Numbers divisible by their individual digits but not by the product of their digits 1-999:"
    as-green n
]
