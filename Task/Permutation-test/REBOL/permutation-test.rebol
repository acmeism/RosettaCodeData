Rebol [
    title: "Rosetta code: Permutation test"
    file:  %Permutation_test.r3
    url:   https://rosettacode.org/wiki/Permutation_test
    note:  "Translated from Julia"
]

;; Splits vector `a` into two sub-vectors based on a block of selected indices.
;; Elements at positions listed in `sel` go into x; all others go into y.
;; Returns a two-element block: [x y]
bifurcate: func [
    a    [vector!]         ; The source to split
    sel  [vector! block!]  ; 1-based indices identifying the "selected" partition
    /local
        x     ; Will hold elements at the selected indices
        y     ; Will hold the remaining elements
        asel  ; Boolean mask, same length as `a`; true = selected, false = remainder
        i     ; Loop counter
][
    x: copy/part a 0 ;; creates an empty vector of the same type like the source
    y: copy x
    ; Build a boolean mask initialised entirely to false
    asel: make bitset! 1 + length? a
    ; Flip the mask to true at every index listed in sel
    foreach idx sel [ asel/:idx: true ]
    ; Walk the mask and route each element of `a` to x or y accordingly
    repeat i length? a [
        either asel/:i [
            append x a/:i   ; Index is selected -> goes to x
        ][
            append y a/:i   ; Index is not selected -> goes to y
        ]
    ]
    reduce [x y]  ; Return both partitions as a two-element block
]

;; Returns all k-element combinations of indices drawn from `lst`.
;; Uses the classical index-advancement algorithm: maintains a combo block
;; of k indices and repeatedly advances the rightmost index that still has
;; room to move, resetting every index to its right to the next consecutive
;; values.  Each valid state of `combo` is snapshot-copied into `result`.
combinations: func [
    lst  [block! vector!] ; Source vector whose indices are combined
    k    [integer!]       ; Number of elements to choose per combination
    /local
        result  ; Accumulator — block of k-element index blocks
        combo   ; Current combination, represented as k ascending indices
        n       ; Length of lst, i.e. the upper bound for any index
        i       ; Cursor: points to the rightmost index still able to advance
][
    result: copy []
    n: length? lst

    ; Edge cases: choosing nothing yields one empty combination;
    ; choosing more than available yields no combinations at all.
    if k = 0  [return reduce [result]]
    if k > n  [return result]

    ; Seed combo with the lexicographically first combination: [1 2 3 ... k]
    combo: case [
        k < 0#FF       [#(uint8!  [])]
        k < 0#FFFF     [#(uint16! [])]
        k < 0#FFFFFFFF [#(uint32! [])]
        else           [#(uint64! [])]
    ]
    repeat i k [append combo i]

    ; `loop 1` is used as a single-pass block so we can record the first
    ; combo before entering the advancement loop.
    loop 1 [
        append/only result copy combo   ; Record the initial combination
        forever [
            ; Scan right-to-left for the rightmost index that can still
            ; be incremented without exceeding its ceiling (n - k + position).
            i: k
            while [i > 0] [
                if combo/:i < (n - k + i) [break]  ; This index has room — stop here
                i: i - 1                           ; This index is maxed out — look left
            ]
            ; If no index could advance, we have exhausted all combinations.
            if i = 0 [break]
            ; Advance the chosen index by one ...
            combo/:i: combo/:i + 1
            ; ... then reset every index to its right to the next consecutive
            ; values, keeping the block strictly ascending.
            if i < k [
                loop k - i [
                    i: i + 1
                    combo/:i: combo/(i - 1) + 1
                ]
            ]
            append/only result copy combo   ; Record this new combination
        ]
    ]
    result  ; Return the full list of combinations
]


;; Performs a two-sample permutation test to assess whether the observed
;; difference in means between `treated` and `control` is statistically
;; surprising under the null hypothesis of no group effect.
;;
;; For every possible way to split the pooled data into two groups of the
;; same sizes as the originals, we check whether the re-split mean difference
;; beats the observed one.  The counts of splits that do and do not beat it
;; give an exact p-value numerator (better / (better + worse)).
permutation-test: function [
    treated  [vector!]  ; Observed values for the treatment group
    control  [vector!]  ; Observed values for the control group
][
    ; Observed effect: mean difference between the two original groups
    effect0: treated/mean - control/mean
    ; Merge both groups into one pool from which all re-splits are drawn
    pool: append copy treated control
    tlen: length? treated   ; Re-splits must have the same size as `treated`
    plen: length? pool      ; Total number of observations

    better: worse: 0   ; Counters for re-splits that beat (or tie/trail) effect0

    ; Iterate over every k-element subset of pool indices, where k = tlen
    foreach subset combinations pool tlen [
        ; Partition the pool into two groups matching the original group sizes
        tc: bifurcate pool subset
        ; Compare the re-split mean difference against the observed effect
        either effect0 < (tc/1/mean - tc/2/mean) [
            ++ better  ; This re-split produced a larger difference
        ][  ++ worse ] ; This re-split matched or fell below effect0
    ]
    reduce [better worse]
]

; --- Example usage ---
treated: #(uint8! [85 88 75 66 25 29 83 39 97])
control: #(uint8! [68 41 10 49 16 65 32 92 28 98])

set [better worse] permutation-test treated control
tot: better + worse

print  "Permutation test using the following data:"
print ["Treated:  " treated]
print ["Control:  " control]
print ["^/There are" tot "different permuted groups of these data."]
print ajoin [" " better ", " round/to (100 * better / tot) 0.001 " showed better than actual results."]
print ajoin [" " worse  ", " round/to (100 * worse  / tot) 0.001 " showed equalivalent or worse results."]
