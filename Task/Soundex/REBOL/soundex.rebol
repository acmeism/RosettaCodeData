Rebol [
    title: "Rosetta code: Soundex"
    file:  %Soundex.r3
    url:   https://rosettacode.org/wiki/Soundex
]

soundex: function/with [
    "Compute the Soundex phonetic code of a string"
    str [string!]
][
    result: copy/part str 1                       ;; start with first letter
    prev: get-code str/1                          ;; code of first char
    foreach c next str [
        if c: get-code c [                        ;; skip uncodeable chars
            if all [c != #"W" c != prev][         ;; skip vowels and duplicates
                append result c
                ;; early exit when length reached
                if 4 == length? result [return result]
            ]
            prev: c
        ]
    ]
    append/dup result #"0" 4 - length? result ;; pad with zeros
][
    code: [                                       ;; phonetic group mappings
        "aeiouy"   #"W"                           ;; vowels (filtered out)
        "bfpv"     #"1"
        "cgjkqsxz" #"2"
        "dt"       #"3"
        "l"        #"4"
        "mn"       #"5"
        "r"        #"6"
    ]
    ;; Return the Soundex digit for a character, or none if uncodeable
    get-code: function [ch [char!]][
        foreach [chars digit] code [
            if find chars ch [return digit]       ;; match char to group
        ]
    ]
]

foreach name [
    "Robert" "Rupert" "Rubin" "Ashcraft" "Ashcroft" "Tymczak"
    "Pfister" "Honeyman" "Moses" "O'Mally" "O'Hara" "D day"
][
    printf [-12 " -> " ][name soundex name]
]
