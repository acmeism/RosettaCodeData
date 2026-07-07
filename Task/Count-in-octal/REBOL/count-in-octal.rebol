Rebol [
    title: "Rosetta code: Count in octal"
    file:  %Count_in_octal.r3
    url:   https://rosettacode.org/wiki/Count_in_octal
]

to-octal: func [
    "Convert integer to octal string."
    n [integer!]
][
    if n <= 0 [ return copy "0" ]
    out: copy ""
    while [n > 0] [
        insert out n % 8 ;; prepend next octal digit
        n: n // 8        ;; integer division
    ]
    out
]

for i 0 40 1 [
    print [
        "number in base 10:" as-green pad i 2
        "is in octal:"       as-green to-octal i
    ]
]
