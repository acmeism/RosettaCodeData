Rebol [
    title: "Rosetta code: Twelve statements"
    file:  %Twelve_statements.r3
    url:   https://rosettacode.org/wiki/Twelve_statements
]

funcs: reduce [
    func [" 1. This is a numbered list of twelve statements" st]
         [12 = length? st]
    func [" 2. Exactly 3 of the last 6 statements are true" st]
         [3 = sum skip st 6]
    func [" 3. Exactly 2 of the even-numbered statements are true" st]
         [2 = sum extract skip st 1 2]
    func [" 4. If statement 5 is true, then statements 6 and 7 are both true" st]
         [either st/5 = 1 [did all [st/6 = 1 st/7 = 1]] [true]]
    func [" 5. The 3 preceding statements are all false" st]
         [0 = sum copy/part skip st 1 3]
    func [" 6. Exactly 4 of the odd-numbered statements are true" st]
         [4 = sum extract st 2]
    func [" 7. Either statement 2 or 3 is true, but not both" st]
         [1 = (st/2 + st/3)]
    func [" 8. If statement 7 is true, then 5 and 6 are both true" st]
         [either st/7 = 1 [did all [st/5 = 1 st/6 = 1]] [true]]
    func [" 9. Exactly 3 of the first 6 statements are true" st]
         [3 = sum copy/part st 6]
    func ["10. The next two statements are both true" st]
         [did all [st/11 = 1 st/12 = 1]]
    func ["11. Exactly 1 of statements 7, 8 and 9 are true" st]
         [1 = sum copy/part skip st 6 3]
    func ["12. Exactly 4 of the preceding statements are true" st]
         [4 = sum copy/part st 11]
]

;; generate all 2^12 boolean combinations
all-combos: function [n] [
    result: make block! 4096
    repeat i (2 ** n) [
        combo: make block! n
        bits: i - 1
        repeat j n [
            ;; insert prepends, so LSB -> index 1 (statement 1)
            insert combo bits and 1
            bits: bits >> 1
        ]
        append/only result combo
    ]
    result
]

full:    copy []
partial: copy []

foreach st all-combos 12 [
    truths:  collect [
        foreach valid? funcs [keep pick [1 0] valid? st]
    ]
    matches: collect [
        repeat i 12 [keep pick [1 0] st/:i = truths/:i]
    ]
    mcount: sum matches
    case [
        mcount = 12 [repend full    [st matches]]
        mcount = 11 [repend partial [st matches]]
    ]
]

indexes: function[blk][
    collect [forall blk [if 1 == blk/1 [keep index? blk]]]
]

print ""
print as-green "Exact hits:"
foreach [st matches] full [
    print [" " mold st "" indexes st]
]
print ""
print as-red "Near misses (one fail):"
foreach [st matches] partial [
    i: index? find matches 0
    print [" " mold st " Fails:" first spec-of :funcs/:i]
]
