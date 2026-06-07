Rebol [
    title: "Rosetta code: Happy numbers"
    file:  %Happy_numbers.r3
    url:   https://rosettacode.org/wiki/Happy_numbers
]

happy?: function [
    "Test if n is a happy number by summing squares of digits until 1 or cycle"
    n [integer!]
][
    cache: clear []                     ;; track seen values to detect cycles
    while [n != 1][
        if find cache n [return false]  ;; cycle detected: not happy
        append cache n                  ;; mark n as seen
        sum: 0
        while [n != 0][                 ;; extract and square each digit
            digit: n % 10               ;; rightmost digit
            sum: sum + (digit * digit)  ;; add square of digit
            n: n // 10                  ;; remove rightmost digit
        ]
        n: sum                          ;; next n is sum of squared digits
    ]
    true                                ;; reached 1: happy!
]

;; Collect first 8 happy numbers by testing candidates in sequence
happy-nums: copy []
num: 0
until [
    ++ num
    all [
        if happy? num [append happy-nums num]
        8 == length? happy-nums
    ]
]

prin ["First 8 happy numbers:" happy-nums]
