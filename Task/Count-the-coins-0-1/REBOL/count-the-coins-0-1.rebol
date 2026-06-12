Rebol [
    title: "Rosetta code: Count the coins/0-1"
    file:  %Count_the_coins_0-1.r3
    url:   https://rosettacode.org/wiki/Count_the_coins/0-1
    note:  "Translated from Julia"
]

all-combinations: func [
    "Returns all subsets (of any size) of `lst`, including the empty set."
    lst [block! vector!]  ; Source block to draw subsets from
    /local result current-subsets new-subsets item sub
][
    ;; Builds the power set iteratively: for each element, extend every
    ;; already-known subset with that element and accumulate the new subsets.
    result: reduce [copy []]   ; Start with just the empty subset
    foreach item lst [
        new-subsets: copy []
        foreach sub result [
            append/only new-subsets append copy sub item  ; Extend each known subset
        ]
        append result new-subsets                         ; Accumulate the new subsets
    ]
    result
]

all-permutations: function [
    "Returns all permutations of `lst` using recursive backtracking."
    lst [block! vector!]  ; Block to permute
][
    ;; At each level, picks every remaining element as the next position
    ;; and recurses on the rest, collecting completed orderings.
    result: copy []
    if  1 == length? lst [return reduce [copy lst]]    ; Base case: one element, one permutation
    repeat i length? lst [
        rest: copy lst
        remove at rest i                               ; Remove the i-th element to recurse on the rest
        foreach perm all-permutations rest [
            append/only result append copy perm lst/:i ; Prepend picked element to each sub-permutation
        ]
    ]
    result
]

coinsum: function [
    "Finds all subsets of `coins` that sum to `targetsum`, then enumerates every ordering of each such subset."
    coins      [block! vector!] ; Available coin denominations (duplicates allowed)
    targetsum  [integer!]       ; Target sum to hit exactly
    /verbose                    ; When present, print each match and its permutations
][
    print rejoin ["Coins are " mold coins ", target sum is " targetsum ":"]
    combos: perms:  0
    foreach choice all-combinations coins [
        if (sum choice) = targetsum [
            combos: combos + 1
            if verbose [print [mold choice "sums to" targetsum]]
            foreach perm all-permutations choice [
                if verbose [print ["    permutation:" mold perm]]
                perms: perms + 1
            ]
        ]
    ]
    print [combos "combinations," perms "permutations.^/"]
    combos
]

coinsum/verbose [1 2 3 4 5] 6
coinsum/verbose [1 1 2 3 3 4 5] 6
coinsum         [1 2 3 4 5 5 5 5 15 15 10 10 10 10 25 100] 40
