Rebol [
    title: "Rosetta code: Best shuffle"
    file:  %Best_shuffle.r3
    url:   https://rosettacode.org/wiki/Best_shuffle
]

count: function [
    {Count positions where s1 and s2 have the same character.}
    s1 [string!] s2 [string!]
][
    res: 0
    repeat i length? s1 [
        if s1/:i == s2/:i [ ++ res ]
    ]
    res
]

best-shuffle: function [
    {Shuffle string minimising positions that match the original.}
    s [string!]
][
    sf: random copy s
    repeat i length? sf [
        if sf/:i != s/:i [continue]
        repeat j length? sf [
            if all [
                sf/:i != sf/:j
                sf/:i != s/:j
                sf/:j != s/:i
            ][
                swap at sf i at sf j
                break
            ]
        ]
    ]
    sf
]

foreach w  [
    "abracadabra" "seesaw" "grrrrrr" "pop"
    "up" "a" "antidisestablishmentarianism"
][
    sf: best-shuffle w
    print ["count:" count w sf "|" w "->" sf ]
]
