logics: func [a [logic!] b [logic!]] [
    print ['and tab a and b]
    print ['or  tab a or  b]
    print ['not tab   not a]
    print ['xor tab a xor b]

    print ['and~ tab and~ a b]
    print ['or~  tab or~  a b]
    print ['xor~ tab xor~ a b]

    print ['any tab any [a b]]
    print ['all tab all [a b]]
]
