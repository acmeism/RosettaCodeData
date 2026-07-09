Rebol [
    title: "Rosetta code: Two identical strings"
    file:  %Two_identical_strings.r3
    url:   https://rosettacode.org/wiki/Two_identical_strings
]

for i 0 1000 1 [
    parse bin: enbase i 2 [remove any #"0"]   ;; binary string, strip leading zeros
    if even? len: length? bin [               ;; only even-length binary strings can match
        if find/match bin skip bin len >> 1 [ ;; first half = second half?
            print [pad i 3 ":" bin]
        ]
    ]
]
