Rebol [
    title: "Rosetta code: Inverted index"
    file:  %Inverted_index.r3
    url:   https://rosettacode.org/wiki/Inverted_index
]

word-search: context [
    indexes: make map! []
    word-chars: complement charset { ^-^/^M.!?,;:'"()-[]{}—}
    make-index: function [
        {Build a word->positions map from a string.}
        file [file!] text [string! none!]
    ][
        unless text [text: read/string file]
        index: make map! []
        print ["Indexing file:" as-yellow file]
        parse text [
            any [
                ;; capture word and its position
                pos: copy word: some word-chars (
                    append any [
                        index/:word
                        index/:word: copy [] ;; init new entry if needed
                    ] index? pos
                )
                | to word-chars              ;; skip delimiters
            ]
        ]
        indexes/:file: index
    ]
    find: function [word [string!]][
        print ["Searching for:" as-green word]
        count: 0
        foreach [file index] indexes [
            if positions: index/:word [
                print [tab "in" as-yellow file "at positions:" ajoin/with positions ", "]
                count: count + length? positions
            ]
        ]
        print either/only zero? count [
            tab "not found!"
        ][  tab "found in" count "positions."]
    ]
]

;; Build per-file indexes
foreach [file str][
    %inv1.txt {It is what it is.}
    %inv2.txt {What is it?}
    %inv3.txt {It is a banana!}
][  word-search/make-index file str ]

print ""
;; Search for some words
foreach word [
    "cat" "is" "banana" "it" "what" "a"
][
    word-search/find word
]
