Rebol [
    title: "Rosetta code: Rep-string"
    file:  %Rep-string.r3
    url:   https://rosettacode.org/wiki/Rep-string
]

rep-string?: function [
    "Return the repeated unit if text is a rep-string, false otherwise"
    text [string!]
][
    len: length? text
    for x len // 2 1 -1 [                     ;; try prefix lengths from mid down to 1
        unit: copy/part at text x + 1 len - 1 ;; suffix of length len-x
        if find/match text unit [             ;; suffix is also a prefix?
            return copy/part text x           ;; return the repeating unit
        ]
    ]
    false
]

foreach str [
    "1001110011"
    "1110111011"
    "0010010010"
    "1010101010"
    "1111111111"
    "0100101101"
    "0100100"
    "101"
    "11"
    "00"
    "1"
][
    rep: rep-string? str
    prin [pad copy str 10 "-> "]
    print either/only rep [
        pad copy rep 5 "( length:" length? rep ")"
    ][  "*not* a rep-string"]
]
