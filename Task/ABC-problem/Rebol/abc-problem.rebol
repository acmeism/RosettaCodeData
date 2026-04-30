Rebol [
    title: "Rosetta code: ABC problem"
    file:  %ABC_problem.r3
    url:   https://rosettacode.org/wiki/ABC_problem
    needs: 3.10.0 ;; or something like that
    note:  "Based on Red language solution"
]
;; Define the function 'test' that takes a string argument 's'
test: function [s [string!]][
    ;; Make a copy of the input string to work on (avoid mutation of original)
    s: copy s
    ;; Initialize 'p' as a copy of a specific character sequence
    p: copy "BOXKDQCPNAGTRETGQDFSJWHUVIANOBERFSLYPCZM"
    ;; Start an infinite loop
    forever [
        ;; If 's' is empty, return true (all characters matched/removed)
        if 0 = length? s [return  true]
        ;; If 'p' is at the tail (all pairs tried), return false (no match)
        if tail? p       [return false]
        ;; Create a parsing rule of the current two characters in 'p'
        rule: reduce [first p  '| second p]
        ;; Try to parse 's' according to the current rule:
        ;; If parsing succeeds, remove that rule from the string
        p: either parse s [to rule remove rule to end ] [
            ;; If parsing succeeded, remove the current pair from 'p'
            head remove/part p 2
        ][
            ;; If parsing failed, skip the current pair in 'p' (move to next pair)
            skip p 2
        ]
    ]
]

;; Test the 'test' function on each word split from a string (split by space).
foreach word split {A bark book TrEAT COmMoN SQUAD conFUsE} space [
    ;; Print the word and its result from 'test'
    printf [8 ": "] reduce [word test word]
]
