Rebol [
   title: "Rosetta code: Wordle comparison"
   file:  %Wordle_comparison.r3
   url:   https://rosettacode.org/wiki/Wordle_comparison
]

wordle: function [
    "Scores a guess against an answer, returning a block of n integers"
    "2 = exact match, 1 = wrong position, 0 = no match"
    answer [string!] "The secret target word"
    guess  [string!] "The player's guessed word"
][
    ;; Ensure both words are the same length; bind n to that length
    assert [(n: length? guess) = (length? answer)]

    ;; Work on a copy so we can null-out consumed letters.
    answer: copy answer

    ;; Build the result block, pre-filled with 0 (= "no match")
    result: copy []
    append/dup result 0 n

    ;; First pass: exact matches (right letter, right position)
    ;; Path syntax a/:i reads the i-th character of string a
    repeat i n [
        if guess/:i = answer/:i [
            answer/:i: 0        ;; Null out consumed letter
            result/:i: 2        ;; Mark position as exact match
        ]
    ]
    ;; Second pass: wrong-position matches
    ;; Only runs on positions not already scored as exact (result/:i is still 0)
    repeat i n [
        if all [zero? result/:i  p: index? find answer guess/:i] [
            answer/:p: 0        ;; Null out to prevent double-counting
            result/:i: 1        ;; Mark position as wrong-position match
        ]
    ]
    result
]

;; Test pairs laid out as a flat block of alternating answer/guess strings
colors: [grey yellow green]
foreach [answer guess][
    "ALLOW" "LOLLY"
    "BULLY" "LOLLY"
    "ROBIN" "ALERT"
    "ROBIN" "SONIC"
    "ROBIN" "ROBIN"
][
    res: wordle answer guess
    res2: collect [foreach i res [keep pickz colors i]]
    print [answer "v" guess "=>" mold res "->" mold res2]
]
