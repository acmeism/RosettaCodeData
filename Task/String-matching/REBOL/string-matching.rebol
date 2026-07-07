Rebol [
    title: "Rosetta code: String matching"
    file:  %String_matching.r3
    url:   https://rosettacode.org/wiki/String_matching
]

;; Define some op wrappers.
starts-with: make op! func [a b][to logic! find/match a b]
ends-with:   make op! func [a b][tail? find/last/tail a b]
occurrences: make op! func [a b /local c][
    c: 0
    while [a: find/tail a b][ ++ c]
    c
]

;; Given two strings, demonstrate the following three types of string matching:
parse [
    "1. Determining if the first string starts with second string"
    [find/match "abcd" "ab"]
    [find/match "abcd" "bc"]
    ["abcd" starts-with "ab"]
    ["abcd" starts-with "bc"]

    "2. Determining if the first string contains the second string at any location"
    [pos: find "abcd" "xx"]
    [pos: find "abcd" "bc"]
    [index? pos]              ;; position (2)
    ["abaab" occurrences "a"] ;; should return 3

    "3. Determining if the first string ends with the second string"
    [tail? find/last/tail "abcd" "bc"]
    [tail? find/last/tail "abcd" "cd"]
    ["abcd" ends-with "bc"]
    ["abcd" ends-with "cd"]
][
    some [
        set title: string! (print as-yellow title)
        some [set test: block! (print [mold/only test "==" mold try test])]
        (print "")
    ]
]
