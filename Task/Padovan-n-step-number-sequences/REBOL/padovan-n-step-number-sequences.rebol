Rebol [
    title: "Rosetta code: Padovan n-step number sequences"
    file:  %Padovan_n-step_number_sequences.r3
    url:   https://rosettacode.org/wiki/Padovan_n-step_number_sequences
]

padovan-sequences: function [
    "Returns a flat block encoding a 2D array of Padovan n-step sequences"
    max-s [integer!]  "Maximum number of steps (must be >= 2)"
    max-e [integer!]  "Maximum number of elements per sequence"
][
    ;; 2D array stored as flat vector, indexed as arr[s][e]
    ;; s ranges 2..max-s, e ranges 1..max-e
    arr: make vector! compose [uint16! ((max-s - 1) * max-e)]

    ;; Index helper: maps (s, e) to a 1-based position in the flat vector
    idx: func [s e] [(s - 2) * max-e + e]

    ;; Sequence 2: P(2,1..3) = 1, then P(2,x) = P(2,x-2) + P(2,x-3)
    repeat x min 3 max-e [ arr/(idx 2 x): 1 ]
    if max-e >= 4 [
        for x 4 max-e 1 [
            arr/(idx 2 x): arr/(idx 2 x - 2) + arr/(idx 2 x - 3)
        ]
    ]
    ;; Sequences 3 and above:
    ;; - seed first (n+1) elements from the previous sequence
    ;; - then P(n,x) = sum of P(n, x-n-1 .. x-2)
    for n 3 max-s 1 [
        repeat x min (n + 1) max-e [
            arr/(idx n x): arr/(idx n - 1 x) ;; inherit seed from sequence n-1
        ]
        for x (n + 2) max-e 1 [
            sum: 0
            for p (x - n - 1) (x - 2) 1 [
                sum: sum + arr/(idx n p)   ;; sum over n consecutive predecessors
            ]
            arr/(idx n x): sum
        ]
    ]
    arr
]

;; Compute sequences for steps 2..8, each showing 15 elements
data: padovan-sequences max-s: 8 max-e: 15
print "Padovan n-step sequences:"
for s 2 max-s 1 [
    prin [s "|"]
    for e 1 max-e 1 [
        val: data/((s - 2) * max-e + e)
        prin pad val -4
    ]
    prin LF
]
