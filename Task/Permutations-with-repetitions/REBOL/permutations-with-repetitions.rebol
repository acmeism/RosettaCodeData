Rebol [
    title: "Rosetta code: Permutations with repetitions"
    file:  %Permutations_with_repetitions.r3
    url:   https://rosettacode.org/wiki/Permutations_with_repetitions
]

permutations-with-repetition: function [
    "Generate all n-length sequences drawn from k values, passing each to a callback."
    "Returns the last sequence if callback requests early termination via break-return."
    n        [integer!]      "Length of each sequence"
    values   [block!]        "Pool of k values to draw from"
    callback [any-function!] "Called with each sequence; return false to stop early"
][
    k: length? values
    indices: make vector! reduce ['uint32! n]
    seq: make block! n   ;; reusable sequence buffer

    loop k ** n [
        ;; build current sequence from indices
        clear seq
        repeat i n [append seq values/(1 + indices/:i)]

        ;; yield to callback with a fresh copy; stop if it returns false
        unless callback seq [return seq] ;; return last sequence on stop

        ;; increment indices like an odometer (rightmost digit first)
        pos: n
        until [
            indices/:pos: digit: (indices/:pos + 1) % k  ;; wrap digit around k
            any [digit <> 0  0 = pos: pos - 1]  ;; carry if wrapped; stop if no more positions
        ]
    ]
    none ;; return none if not stopped
]

;; Example 1: probe all 2-length sequences from [a b c]
print "All 2-length sequences from [a b c]:"
permutations-with-repetition 2 [a b c] :probe

;; Example 2: crack a combination lock — stop on first match
print "^/Cracking lock [2 0 1]:"
target: [2 0 1] attempts: 0
lock: permutations-with-repetition 3 [0 1 2 3 4 5 6 7 8 9] func [seq] [
    ++ attempts
    either seq = target [
        print [mold seq "found after" attempts "attempts"]
        false  ;; stop early
    ][  true ] ;; continue
]
?? lock
