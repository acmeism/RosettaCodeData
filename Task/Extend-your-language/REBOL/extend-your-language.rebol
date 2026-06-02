Rebol [
    title: "Rosetta code: Extend your language"
    file:  %Extend_your_language.r3
    url:   https://rosettacode.org/wiki/Extend_your_language
]

if2: func [cond1 cond2 both one two none][
    case [
        all [cond1 cond2] both
        cond1             one
        cond2             two
        true              none
    ]
]

loop 5 [
    printf ["a is" -3 ", b is" -3 ";" -15 " < 50"]
    if2 (a: random 100) < 50
        (b: random 100) < 50
        [[a b "both are"      ]]
        [[a b "only first is" ]]
        [[a b "only second is"]]
        [[a b "none is"       ]]
]
