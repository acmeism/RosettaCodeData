Rebol [
    title: "Rosetta code: Longest common suffix"
    file:  %Longest_common_suffix.r3
    url:   https://rosettacode.org/wiki/Longest_common_suffix
]

longest-common-suffix: function [
    words [block!] "Block of strings to find the common suffix of"
][
    if single? words [return words/1] ;; A single word is its own suffix
    p: -1 ;; Negative offset from tail: -1 = last char, -2 = second-to-last...
    o: copy ""
    ;; Pick the character at position p from the tail of the first word
    ;; If we've walked past the start of the word, stop
    while [c: pick tail words/1 p ][
        ;; Check the same position in every other word
        foreach w next words [
            ;; Stop if this word is shorter than the current offset
            ;; or if its character doesn't match the reference character
            if any [c != pick tail w p] [ return o ]
        ]
        -- p        ;; Step one character further from the tail
        insert o c  ;; Prepend the matched character to build the suffix
    ]
    o
]
; --- test cases ---
foreach words [
    ["Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday"]
    ["throne"]             ;; Single word: returned as-is
    ["throne" "throne"]    ;; Identical words: full word is the suffix
    ["throne" "throne" ""] ;; Empty string: common suffix is ""
][
    print [
        "Longest common suffix of words:" mold words
        "is" as-green mold longest-common-suffix words
    ]
]
