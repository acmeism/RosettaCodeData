Rebol [
    title: "Rosetta code: Changeable words"
    file:  %Changeable_words.r3
    url:   https://rosettacode.org/wiki/Changeable_words
]

words: read/lines %unixdict.txt

count: 0
forall words [
    word1: words/1
    if 12 > len: word1/length [continue] ;; skip words shorter than 12 chars
    foreach word2 next words [
        one-diff: false                  ;; have we seen a differing char yet?
        if all [
            len == word2/length
            repeat i len [
                if word1/:i != word2/:i [
                    if one-diff [break/return false]  ;; second difference - not a match
                    one-diff: true                    ;; first difference found
                ]
                one-diff
            ]
        ][
            printf [-18 " <-> "] [word1 word2]
            ++ count
        ]
    ]
]
print ["^/Found" count * 2 "changeable words."]
