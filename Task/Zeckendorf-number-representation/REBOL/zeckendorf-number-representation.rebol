Rebol [
    title: "Rosetta code: Zeckendorf number representation"
    file:  %Zeckendorf_number_representation.r3
    url:   https://rosettacode.org/wiki/Zeckendorf_number_representation
]

zeckendorf: function [
    "Returns Zeckendorf representation of a non-negative integer"
    n [integer!]
][
    if n = 0 [ return #"0" ]
    fibs: copy [2 1]                     ;; build Fibonacci list down to 1
    while [n > fibs/1] [
        insert fibs fibs/1 + fibs/2      ;; prepend next Fibonacci number
    ]
    result: copy ""
    foreach f fibs [
        append result either f <= n [n: n - f #"1"][#"0"]  ;; greedy fit
    ]
    if result/1 = #"0" [ remove result ] ;; drop leading zero
    result
]

for i 0 20 1 [
    print [pad i -3 "|" zeckendorf i]
]
