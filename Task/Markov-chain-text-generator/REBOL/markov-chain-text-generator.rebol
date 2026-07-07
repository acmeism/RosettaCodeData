Rebol [
    title: "Rosetta code: Markov chain text generator"
    file:  %Markov_chain_text_generator.r3
    url:   https://rosettacode.org/wiki/Markov_chain_text_generator
]

markov: function [
    {Generates text using a Markov chain model built from the given file}
    file-path   [file!]
    key-size    [integer!]
    output-size [integer!]
] [
    assert [key-size > 0 "Key size can't be less than 1"]

    words: split trim/tail read/string file-path SP

    assert [all [
        output-size > key-size
        output-size < length? words
        "Output size is out of range"
    ]]

    dict: make map! (length? words) / 3

    forall words [
        prefix: ajoin/with copy/part words key-size SP
        append any [
            dict/:prefix
            dict/:prefix: copy []        ;; create entry if missing
        ] words/(1 + key-size)           ;; next word or none at end of text
    ]

    prefix: random/only keys-of dict     ;; random starting prefix
    output: split prefix SP

    negated-key-size: negate key-size

    loop length? words [                 ;; upper bound to prevent infinite loop
        next-words: dict/:prefix
        if any [none? next-words none? first next-words] [break]
        append output random/only next-words
        if output-size <= length? output  [break]
        prefix: ajoin/with skip tail output negated-key-size SP
    ]

    ajoin/with copy/part output output-size SP
]


unless exists? %alice_oz.txt [
    write %alice_oz.txt
     read http://paulo-jorente.de/text/alice_oz.txt
]

print markov %alice_oz.txt 3 100
