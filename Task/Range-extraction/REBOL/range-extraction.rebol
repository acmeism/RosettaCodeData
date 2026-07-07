Rebol [
    title: "Rosetta code: Range extraction"
    file:  %Range_extraction.r3
    url:   https://rosettacode.org/wiki/Range_extraction
]

extract-range: function/with [
    "Compress a sorted block of integers into a compact range string."
    integers [block! string!] "Block of integers in increasing order, e.g. [1 2 3 5 7 8 9]"
][
    if string? integers [
        ;; normalize comma-separated string input into a block of integers
        integers: sort transcode replace/all copy integers #"," #" "
    ]
    if empty? integers [return ""]

    start: first integers    ;; begin of current run
    prev:  start             ;; last seen value
    out:   clear ""          ;; reset shared output buffer
    foreach n next integers [
        either n = (prev + 1) [
            prev: n          ;; extend current run
        ][
            ;; gap found - emit completed run, start a new one
            emit start prev
            start: prev: n
        ]
    ]
    emit start prev          ;; emit final run
    copy next out            ;; return string, skipping the leading comma
][
    out: ""                  ;; shared output buffer (reset each call via clear "")
    emit: func [s e] [
        ;; spans of 1 or 2 integers are emitted as individual values, 3+ as s-e
        repend out either e - s > 1 [
            [#"," s #"-" e]
        ][
            either/only s = e [#"," s] [#"," s #"," e]
        ]
    ]
]

probe compress-range {
0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
37, 38, 39}
probe compress-range [1 2 3 5 7 8 9]
