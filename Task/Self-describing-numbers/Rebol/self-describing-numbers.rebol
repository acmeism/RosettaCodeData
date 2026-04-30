Rebol [
    title: "Rosetta code: Self-describing numbers"
    file:  %Self-describing_numbers.r3
    url:   https://rosettacode.org/wiki/Self-describing_numbers
]

self-describing?: function [
    {Return true if every digit at position N equals the count of N's in the number.
    E.g. 2020 has two 0s, zero 1s, two 2s, zero 3s -> self-describing.}
    number [integer!]
][
    digit: #"0"   ;; walk digits 0-9 in parallel with positions
    str: append clear "" number  ;; reusing the string
    foreach ch str [
        ;; Count how many times a digit appears in a number string.
        cnt: #"0" ;; char counter avoids int conversion
        parse str [any [to digit (++ cnt) skip]]
        if ch != cnt [ return false ]
        ++ digit
    ]
    true
]

repeat i 4000000 [ if self-describing? i [ print i ] ]
