Rebol [
    title: "Rosetta code: Bell numbers"
    file:  %Bell_numbers.r3
    url:   https://rosettacode.org/wiki/Bell_numbers
]

bell-triangle: function [
    "Compute Bell triangle with n rows (1-based; row 0 unused)."
    n [integer!]
][
    tri: make block! n
    repeat i n [append/only tri array/initial i 0]  ;; row i has i zero-filled elements
    tri/2/1: 1                                      ;; seed: first element of row 2
    for i 3 n 1 [
        tri/:i/1: tri/(i - 1)/(i - 2)               ;; first element = second-to-last of previous row
        for j 2 i 1 [
            tri/:i/:j: tri/:i/(j - 1) + tri/(i - 1)/(j - 1) ;; sum of left and upper-left
        ]
    ]
    tri
]

bt: bell-triangle 16

print "First fifteen Bell numbers:"
for i 1 15 1 [
    printf [-2 ": "] [i bt/(i + 1)/1]
]
print "^/The first ten rows of Bell's triangle:"
for i 1 10 1 [
    print bt/(i + 1)
]
