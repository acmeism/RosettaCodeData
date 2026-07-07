Rebol [
    title: "Rosetta code: Unique characters"
    file:  %Unique_characters.r3
    url:   https://rosettacode.org/wiki/Unique_characters
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
probe unique-chars ["133252abcdeeffd" "a6789798st" "yxcdfgxcyz"]
