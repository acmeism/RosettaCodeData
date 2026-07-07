Rebol [
    title: "Rosetta code: Unique characters in each string"
    file:  %Unique_characters_in_each_string.r3
    url:   https://rosettacode.org/wiki/Unique_characters_in_each_string
]

unique-chars: function [
    "Returns string of unique characters from a block of strings, sorted"
    block [block!]
][
    str: sort ajoin block      ;; flatten & sort so duplicates are adjacent
    out: copy ""
    forall str [
        if str/1 != str/2 [append out str/1] ;; first occurrence → keep
        while [str/1 == str/2] [++ str]      ;; skip consecutive duplicates
    ]
    out
]

unique-in: function [
    "Returns string of chars appearing exactly once in every string in block"
    block [block!]
][
    out: unique-chars [block/1]             ;; unique chars in first string
    foreach str next block [
        out: intersect out unique-chars [str]  ;; keep common uniques
    ]
    out
]

probe unique-in ["1a3c52debeffd" "2b6178c97a938stf" "3ycxdb1fgxa2yz"]
