Rebol [
    title: "Rosetta code: Roman numerals/Encode"
    file:  %Roman_numerals-Encode.r3
    url:   https://rosettacode.org/wiki/Roman_numerals-Encode
]

arabic-to-roman: function [
    "Converts a positive integer to a Roman numeral string; returns NONE for out-of-range input"
    n [integer!] "Positive integer (1–3999)"
][
    if any [n < 1  n > 3999] [return none]
    result: copy ""
    foreach [value symbol] [
        1000 M  900 CM  500 D  400 CD
         100 C   90 XC   50 L   40 XL
          10 X    9 IX    5 V    4 IV  1 I
    ][
        while [n >= value] [append result symbol  n: n - value]
    ]
    result
]

foreach number [40 33 1888 2016][
    printf [5 ": "] [number arabic-to-roman number]
]
