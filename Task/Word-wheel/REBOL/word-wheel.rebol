Rebol [
    title: "Rosetta code: Word wheel"
    file:  %Word_wheel.r3
    url:   https://rosettacode.org/wiki/Word_wheel
]

solve-word-wheel: closure/with [
    "Find all valid words from a word-wheel puzzle."
    wheel      [string!]  "The wheel letters (center letter at middle index)."
    dictionary [block!]   "List of candidate words."
    size-floor [integer!] "Minimum word length."
][
    wheel-tally: charset-tally wheel
    center: wheel/((1 + length? wheel) / 2)    ;; middle letter

    collect [
        foreach word dictionary [
            if all [
                size-floor <= length? word
                find word center               ;; must use center letter
                every-key?  word wheel-tally   ;; all letters exist in wheel
                tally-fits? word wheel-tally   ;; letter counts don't exceed wheel
            ][
                keep word
            ]
        ]
    ]
][
    charset-tally: func [
        ;; Count occurrences of each character in a string.
        str [string!]
    ][
        tally: make map! []
        foreach ch str [
            tally/:ch: 1 + any [tally/:ch 0]
        ]
        tally
    ]

    every-key?: func [
        ;; Check that every char in word exists as a key in tally.
        word  [string!]
        tally [map!]
    ][
        foreach ch word [
            unless tally/:ch [return false]
        ]
        true
    ]

    tally-fits?: func [
        ;; Check word's char counts don't exceed the wheel's tally.
        word  [string!]
        tally [map!]
    ][
        word-tally: charset-tally word
        foreach ch word [
            if word-tally/:ch > tally/:ch [return false]
        ]
        true
    ]
]

words: read/lines %unixdict.txt
foreach word solve-word-wheel "ndeokgelw" words 3 [
    print word
]

