Rebol [
    title: "Rosetta code: Amb"
    file:  %Amb.r3
    url:   https://rosettacode.org/wiki/Amb
    note: "Based on Red language implementation!"
]
; findblock: Walk a block tree and find the first WORD! whose value is a BLOCK!
;            This identifies the next nondeterministic choice variable to expand.
findblock: func [
    blk [block!]
][
    foreach w blk [
        ; If w is a word and its value (get w) is a block, we found a choice point.
        if all [word? w block? get w] [return w]
        ; If w is itself a block, recurse to search deeper for a choice point.
        if block? w [findblock w]
    ]
]

;; Rebol does not provide replace/deep as Red, so use this function.
; replace-deep: Deeply replace occurrences of a (needle) with b (replacement)
;               across a nested block structure. Useful for substituting a choice
;               variable with one concrete alternative throughout the condition.
replace-deep: func [blk a b][
    ; Do a shallow replace for direct occurrences at this level.
    replace/all blk a b
    ; Walk the block; whenever we see a nested block, recurse.
    forall blk [
        if any-block? blk/1 [
            replace-deep blk/1 a b
        ]
    ]
    blk
]

; amb: Evaluate a condition with nondeterministic choices.
;      The condition is expressed as a block containing logic and possibly
;      choice variables (words whose values are blocks of alternatives).
;      amb returns TRUE if there exists an assignment of choices that makes
;      the condition succeed; otherwise FALSE.
amb: func [
    cond [block!]
    /local b cond2
][
    ; Look for the next choice variable (a WORD! whose value is a BLOCK!)
    either b: findblock cond [
        ; For each alternative 'a' in the domain of choice variable 'b'
        foreach a get b [
            ; Create a new version of the condition where 'b' is replaced by 'a'
            cond2: replace-deep copy/deep cond b a
            ; Recurse: if any branch succeeds, lock in this choice and return TRUE
            if amb cond2 [
                set b a          ; Commit the successful choice to the variable
                return true
            ]
        ]
        ; If no alternative leads to success, this branch fails (implicit NONE/falsey)
    ][
        ; Base case: No more choice variables; directly evaluate the condition.
        ; If it evaluates to TRUE, this path is a solution; otherwise it fails.
        do cond
    ]
]


; examples
x: [1 2 3 4]
y: [4 5 6]
z: [5 2]
print amb [x * y * z = 8]
print [x y z]

a: ["the" "that" "a"]
b: ["frog" "elephant" "thing"]
c: ["walked" "treaded" "grows"]
d: ["slowly" "quickly"]
print amb [
    all [
        equal? last a first b
        equal? last b first c
        equal? last c first d
    ]
]
print [a b c d]
