Rebol [
    title: "Rosetta code: Gray code"
    file:  %Gray_code.r3
    url:   https://rosettacode.org/wiki/Gray_code
]

grey-encode: function [
    "Return the Grey code of n."
    n [integer!]
][
    n xor (n >> 1)  ;; XOR with right-shifted self
]

grey-decode: function [
    "Decode a Grey-coded integer back to binary."
    n [integer!]
][
    p: n
    n: n >> 1
    while [n != 0][
        p: p xor n
        n: n >>  1  ;; peel off one bit at a time
    ]
    p
]

for i 0 31 1 [
    g: grey-encode i
    b: grey-decode g
    print [
        pad i -2
        ":" enbase i 2 "⇾" enbase g 2 "⇾" enbase b 2 ":"
        pad b 2
    ]
]
