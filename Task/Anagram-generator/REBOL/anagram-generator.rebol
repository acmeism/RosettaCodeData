Rebol [
    title: "Rosetta code: Anagram generator"
    file:  %Anagram_generator.r3
    url:   https://rosettacode.org/wiki/Anagram_generator
]

file: %unixdict.txt
unless exists? file [
    print "Downloading wordlist."
    write file read https://raw.githubusercontent.com/thundergnat/rc-run/refs/heads/master/rc/resources/unixdict.txt
]
words-raw: read/lines file

;; Build word map from dictionary
word-map: make map! []

foreach w words-raw [
    sorted-key: sort copy w
    either find word-map sorted-key [
        append word-map/:sorted-key w
    ][
        put word-map sorted-key reduce [w]
    ]
]

create-combinations: function [
    "Generate all k-length combinations of characters from a string"
    word [string!] k [integer!]
][
    combos: copy []
    n: length? word
    indices: copy []

    ;; Initialize first combination (first k indices)
    repeat i k [append indices i]

    forever [
        ;; Extract combination
        combo: copy ""
        foreach idx indices [append combo word/:idx]
        append combos combo

        i: k
        while [i >= 1] [
            if (pick indices i) < (n - k + i) [break]
            -- i
        ]
        if i < 1 [break]

        ;; Increment and fill forward
        indices/:i: indices/:i + 1
        loop (k - i) [
            indices/(i + 1): indices/:i + 1
            ++ i
        ]
    ]
    combos
]

set-difference-strings: function [
    "Compute sorted set-difference of two sorted strings"
    a [string!] b [string!]
][
    result: copy ""
    i: j: 1
    while [i <= length? a] [
        either all [j <= length? b  a/:i = b/:j][
            ++ j
        ][  append result a/:i ]
        ++ i
    ]
    result
]

anagram-generator: function [
    "Main anagram generator"
    input-word [string!]
][
    ;; Normalize the input: lowercase, sort alphabetically, strip non-alpha characters.
    ;; parse with the alpha bitset removes any character that isn't a letter,
    ;; leaving a clean, sorted string of lowercase letters to work with.
    word: sort lowercase copy input-word
    alpha: system/catalog/bitsets/alpha
    parse word [any [some alpha | remove skip]]

    ;; Track letter-combinations we've already processed to avoid duplicate anagram pairs.
    previous-letters: #[]

    ;; Start at half the word length (right-shift by 1 = integer divide by 2).
    ;; We only need to check splits up to half, since the other half is the complement.
    n: (length? word) >> 1
    while [n >= 1] [
        ;; Generate all n-character combinations from the sorted word.
        foreach letters-one create-combinations word n [
            sorted-one: sort copy letters-one

            ;; Skip this combination if we've already seen it, to avoid producing
            ;; duplicate pairs (e.g. "abc"/"def" and "def"/"abc" are the same pair).
            unless find previous-letters sorted-one [
                previous-letters/:sorted-one: true

                ;; Look up whether this letter-set forms any known words.
                anagrams-one: word-map/:sorted-one
                if anagrams-one [
                    ;; Derive the complementary letter-set: whatever letters remain
                    ;; after removing letters-one from the full word.
                    letters-two: set-difference-strings word sorted-one

                    ;; When the word splits exactly in half (n = half length), both
                    ;; halves are the same size so each unordered pair will appear
                    ;; twice. Guard against this by also marking letters-two as seen;;
                    ;; if it was already marked, skip to the next combination.
                    if (length? word) = (2 * n) [
                        if previous-letters/:letters-two [
                            -- n
                            continue
                        ]
                        previous-letters/:letters-two: true
                    ]

                    ;; Look up whether the complementary letter-set forms any known words.
                    anagrams-two: word-map/:letters-two
                    if anagrams-two [
                        ;; Both halves are valid words — print every pairing.
                        foreach w1 anagrams-one [
                            foreach w2 anagrams-two [
                                print rejoin [" " w1 " " w2]
                            ]
                        ]
                    ]
                ]
            ]
        ]
        -- n
    ]
]

;; Test words
test-words: ["Rosetta code" "Joe B'iden" "Clint Eastw3ood"]
foreach tw test-words [
    print rejoin ["Two word anagrams of " tw ":"]
    anagram-generator tw
    print ""
]
