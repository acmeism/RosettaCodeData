Rebol [
    title: "Rosetta code: Lyndon word"
    file:  %Lyndon_word.r3
    url:   https://rosettacode.org/wiki/Lyndon_word
]

lyndon-words: function/with [
    "Prints Lyndon words"
    alphabet   [string!]
    max-length [integer!]
][
    print ["Lyndon words with max length" max-length "for alphabet" mold alphabet]
    word: copy/part alphabet 1
    while [not empty? word][
        print word
        word: next-word max-length word alphabet
    ]
    print ""
][
    next-word: function[
        "Using the Duval (1988) algorithm"
        max-length [integer!]
        word       [string!]
        alphabet   [string!]
    ][
        ;; Step 1: Repeat the word and truncate
        next-word: copy word
        append/dup next-word word max-length / length? next-word
        clear skip next-word max-length

        ;; Step 2: Remove last symbol of the next word if it is the last symbol in the alphabet
        alphabet-last-symbol: last alphabet
        while [alphabet-last-symbol == last next-word][take/last next-word]

        ;; Step 3: Replace the last symbol of the next word by its successor in the alphabet
        unless empty? next-word [
            word-last-symbol: take/last next-word
            append next-word second find alphabet word-last-symbol
        ]
        next-word
    ]
]

lyndon-words "01" 5
lyndon-words "012" 3
