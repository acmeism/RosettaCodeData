Rebol [
    title: "Rosetta code: Burrows–Wheeler transform"
    file:  %Burrows–Wheeler_transform.r3
    url:    https://rosettacode.org/wiki/Burrows–Wheeler_transform
]

bwt: function [
    "Burrows–Wheeler Transform"
    input [string!] "The original text to encode"
][
    ;; Add sentinel markers:
    ;;   STX (^(02)) at the front to mark the start
    ;;   ETX (^(03)) at the end to mark the terminus
    ;; These ensure unambiguous reconstruction and a fixed sort position.
    input: rejoin [#"^(02)" input #"^(03)"]
    len: length? input           ;; Length of the sentinel-marked string
    rotations: clear []          ;; Will hold all cyclic rotations of the string
    ;; Generate all cyclic rotations:
    repeat i len [
        append rotations rejoin [
            copy   at input i           ;; from position i to end
            copy/part input i - 1       ;; then from start up to (i-1)
        ]
    ]
    ;; Sort all rotations lexicographically
    rotations: sort rotations
    transformed: copy ""         ;; This will be the BWT output (last column)
    ;; Take the last character from each sorted rotation and accumulate
    foreach r rotations [
        append transformed last r
    ]
    ;; Return the "last column" as the BWT-transformed string
    transformed
]


ibwt: function [
    "Inverse Burrows–Wheeler Transform"
    input [string!] "The BWT-produced last column string"
][
    ;; Make a copy so we preserve the original argument
    input: copy input
    len: length? input           ;; Number of rows/characters
    ;; Initialise a table (block of strings), initially containing `len` empty strings
    table: make block! len
    loop len [append table copy ""]
    ;; Rebuild rotation table iteratively:
    ;; Each iteration:
    ;;   1. Prepend each character of last column to corresponding row
    ;;   2. Sort the rows
    repeat j len [
        repeat i len [
            insert table/:i input/:i   ;; insert char from last column at row start
        ]
        table: sort table              ;; keep table lexicographically sorted
    ]
    ;; After len iterations, table contains all sorted rotations.
    ;; The original rotation is the one starting with STX and ending with ETX.
    ;; With STX as the smallest char, it will always be the first row (table/1).
    if table/1/1 == #"^(02)" [
        ;; Skip STX, copy the rest minus ETX.
        ;; `next table/1` skips first char (STX)
        ;; `len - 2` excludes both sentinels
        copy/part next table/1 len - 2
    ]
]

; Example usage
foreach text [
    "banana"
    "appellee"
    "abracadabra"
    "TO BE OR NOT TO BE OR WANT TO BE OR NOT?"
    "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES"
][
    print ["Original text:               " mold text]
    print ["After transformation:        " mold a:  bwt text]
    print ["After inverse transformation:" mold b: ibwt a lf]
    assert [b == text]
]
