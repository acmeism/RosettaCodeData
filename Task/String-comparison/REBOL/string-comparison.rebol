Rebol [
    title: "Rosetta code: String comparison"
    file:  %String_comparison.r3
    url:   https://rosettacode.org/wiki/String_comparison
]

print-comparison: func [a b /local s] [
    prin format [8 "and " 7 ": "] [mold a mold b]
    ; Equality checks
    prin case [
        a == b ["strict equal, "]
        a  = b ["equal, "]
        'else   "not equal at all, "
    ]
    ; Inequality
    if a != b  [prin "!=, "]
    if a < b   [prin "before, "]
    if a > b   [prin "after, "]
    ; For strict compare using `sort` first.
    s: sort/case reduce [a b]
    prin either a == s/1 ["strict before, "]["strict after, "]
    prin either a <= b ["<=, "]["not <=, "]
    prin either a >= b [">=." ]["not >=."]
    prin newline
]

foreach [a b][
    "this" "that"
    "that" "this"
    "THAT" "That"
    "this" "This"
    "this" "this"
    "the"  "there"
    "there" "the"
    "24" "123"
    24 123
    1000 1000.0
    1001 1000.0
][  print-comparison a b ]
