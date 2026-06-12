gospers-hack: function [
    "Given a bitmask, returns the next integer with the same number of set bits"
    n [integer!]
][
    c: n and negate n                 ;; lowest set bit
    r: n + c                          ;; clear the lowest run of set bits and set the next bit
    r or (((n xor r) / c) >> 2)       ;; restore the trailing set bits in the lowest positions
]

foreach n [1 3 7 15][
    prin ajoin [as-red pad n -2 ": "] ;; print starting value
    loop 10 [                         ;; print next 10 values in sequence
        n: gospers-hack n
        prin pad n 4
    ]
    prin LF
]
