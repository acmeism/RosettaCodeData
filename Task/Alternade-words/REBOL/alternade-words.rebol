Rebol [
    title: "Rosetta code: Alternade words"
    file:  %Alternade_words.r3
    url:   https://rosettacode.org/wiki/Alternade_words
]

words: read/lines %unixdict.txt

foreach word words [
    if 6 > length? word [continue]

    ;; split word into odd- and even-indexed characters (1-based)
    alt1: clear ""
    alt2: clear ""
    repeat i length? word [
        append either odd? i [alt1][alt2] word/:i
    ]

    ;; check if both halves are valid words
    if all [
        find words alt1
        find words alt2
    ][
        printf [10 "->" -5 " "] [word alt1 alt2]
    ]
]
