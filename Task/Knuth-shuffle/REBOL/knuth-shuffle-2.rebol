Rebol [
    title: "Rosetta code: Knuth shuffle"
    file:  %Knuth_shuffle.r3
    url:    https://rosettacode.org/wiki/Knuth_shuffle
]
fisher-yates: func [
    "Fisher-Yates shuffle algorithm - randomly shuffles elements in a block"
    ;Uses the modern variant that works backwards through the array
    data [series!] "Input block to shuffle"
    /local i j tmp ;; Local variables: i=current index, j=random index, tmp=swap variable
][
    ;; Make a copy of the input block and get its length
    ;; This prevents modification of the original block
    i: length? data: copy data

    ;; Loop from the last element down to the second element
    ;; We stop at 1 because there's no need to swap the first element with itself
    while [i > 1] [
        ;; Generate random index j from 1 to i (inclusive)
        j: random i
        ;; Previous version tried to avoid self-swap as an optimization
        ;; but actually it is faster to avoid it!

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

    ;; Return the shuffled block
    data
]

random/seed 0 ;; to get consistent results

probe fisher-yates []
probe fisher-yates [10]
probe fisher-yates [10 20]
probe fisher-yates [10 20 30]
