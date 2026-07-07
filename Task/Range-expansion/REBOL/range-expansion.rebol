Rebol [
    title: "Rosetta code: Range expansion"
    file:  %Range_expansion.r3
    url:   https://rosettacode.org/wiki/Range_expansion
]

expand-range: function/with [
    "Expand a compact range string into a block of integers."
    range [string!] "Range expression, e.g. {1-3,5,7-9}"
][
    out: copy []
    parse range [
        any [
            copy s: integer     ;; capture start number (or lone value)
            [
                any space #"-" copy e: integer (
                    ;; span: append every integer from s to e inclusive
                    for i to integer! s to integer! e 1 [append out i]
                )
                | (append out to integer! s) ;; lone integer: append as-is
            ]
            any space
            [#"," | end] ;; consume separator or stop at end
        ]
    ]
    out
][
    digits:  charset [#"0" - #"9"]            ;; character set for digit recognition
    integer: [any space opt #"-" some digits] ;; rule: optional sign + digit run
]

probe expand-range "-6,-3--1,3-5,7-11,14,15,17-20"
probe expand-range "-6, -3 - -1, 3-5, 7 - 11, 14, 15, 17-20"
