Rebol [
    title: "Rosetta code: Letter frequency"
    file:  %Letter_frequency.r3
    url:   https://rosettacode.org/wiki/Letter_frequency
]

letter-frequency: function[
    text [string! file! url!]
    /limit chars [bitset!] "count only chars in this bitset"
    /case                  "case-sensitive search"
][
    dict: make map! 24
    unless string? text [text: read/string text]
    foreach c text [
        unless case [c: lowercase c]                    ;; normalise to lowercase unless /case
        if all [limit not find/:case chars c][continue] ;; skip chars outside allowed set
        put/:case dict c either n: dict/:c [n + 1][1]   ;; increment or initialise counter
    ]
    dict
]

;; Example:
print ["Using input:" as-green mold str: "aa B cC!"]
alpha: charset [#"a"-#"z" #"A"-#"Z"]
foreach test [
    [letter-frequency :str]
    [letter-frequency/limit :str :alpha]
    [letter-frequency/limit/case :str :alpha]
    [letter-frequency/limit %Letter_frequency.r3 :alpha]
][
    print [mold/only test "^/;==" mold/flat try test]
]
