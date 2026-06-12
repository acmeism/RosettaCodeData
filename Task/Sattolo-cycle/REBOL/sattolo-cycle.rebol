Rebol [
    title: "Rosetta code: Sattolo cycle"
    file:  %Sattolo_cycle.r3
    url:    https://rosettacode.org/wiki/Sattolo_cycle
]

sattolo-cycle: func [
    "Sattolo's algorithm - generates a random cyclic permutation"
    ;; Unlike Fisher-Yates, this ensures every element moves to a different position
    ;; Creates a single cycle that visits all elements exactly once
    data [series!]  "Input block to create cyclic permutation of"
    /local i j tmp  ;; Local variables: i=current index, j=random index, tmp=swap variable
][
    ;; Make a copy of the input block and get its length
    ;; This prevents modification of the original block
    i: length? data: copy data

    ;; Loop from the last element down to the second element
    ;; Key difference from Fisher-Yates: we stop at element 2, not 1
    while [i > 1] [
        ;; CRITICAL: Generate random index j from 1 to i-1 (exclusive of i)
        ;; This is what makes it Sattolo's algorithm instead of Fisher-Yates
        ;; In Rebol, random i gives 1 to i, so random (i - 1) gives 1 to i-1
        j: random (i - 1)

        ;; Three-step swap using path notation for direct block access
        ;; Step 1: Store element at random position j in temporary variable
        tmp: data/:j

        ;; Step 2: Move current element (at position i) to random position j
        data/:j: data/:i

        ;; Step 3: Move stored element to current position i
        ;; Using :tmp to get the value (word evaluation)
        data/:i: :tmp

        ;; Move to previous element (working backwards through the block)
        i: i - 1
    ]

    ;; Return the block with cyclic permutation
    ;; Every element is guaranteed to be in a different position than it started
    data
]


random/seed 0 ;; to get consistent results

probe sattolo-cycle [1 2 3]
probe sattolo-cycle "abcde"
