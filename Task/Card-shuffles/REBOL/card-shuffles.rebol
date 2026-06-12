Rebol [
    title: "Rosetta code: Card shuffles"
    file:  %Card_shuffles.r3
    url:   https://rosettacode.org/wiki/Card_shuffles
]

riffle-shuffle: function [
    "Riffle shuffle a block n times"
    list  [block!]
    flips [integer!]
][
    len: length? list
    loop flips [
        ;; cut point: middle +/- 10%
        cut: (len / 2) + ((random/only [-1 1]) * (random len / 10))
        ;; split deck into two halves
        llist: copy/part list cut
        rlist: copy/part skip list cut (len - cut)
        ;; start indices at the tail of each half
        indl: cut
        indr: len - cut
        ind:  len
        ;; interleave from back: bias toward larger remaining half
        while [all [indl >= 1  indr >= 1]][
            list/:ind: either (random 1.0) < (indl / (2 * indr)) [
                llist/(-- indl)
            ][  rlist/(-- indr) ]
            -- ind
        ]
        ;; flush remaining right half
        while [indr >= 1][
            list/:ind: rlist/:indr
            -- indr -- ind
        ]
        ;; flush remaining left half
        while [indl >= 1][
            list/:ind: llist/:indl
            -- indl -- ind
        ]
    ]
    list
]

overhand-shuffle: function [
    "Overhand shuffle a block n times"
    list   [block!]
    passes [integer!]
][
    otherhand: make block! len: length? list
    loop passes [
        ind: 1
        ;; peel chunks from back to front, append to other hand
        while [ind <= len][
            ;; random chunk size: up to 1/5 of deck, capped at remainder
            chklen: min (1 + random (len / 5)) (len - ind + 1)
            ;; copy chunk from back of deck
            append otherhand copy/part skip list (len - ind - chklen + 1) chklen
            ind: ind + chklen
        ]
        ;; transfer result back into list
        append clear list take/all otherhand
    ]
    list
]

fisher-yates-shuffle: function [
    "Fisher-Yates in-place shuffle"
    list [block!]
][
    len: length? list
    repeat i len [
        ;; pick random position from i to end
        j: i + random (len - i)
        ;; swap current with randomly chosen element
        swap at list i at list j
    ]
    list
]

random/seed 1
v: [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20]
print ["Shuffling values    " mold v]
print ["Riffle shuffle 1    " mold riffle-shuffle       copy v 1 ]
print ["Riffle shuffle 10   " mold riffle-shuffle       copy v 10]
print ["Overhand shuffle 1  " mold overhand-shuffle     copy v 1 ]
print ["Overhand shuffle 10 " mold overhand-shuffle     copy v 10]
print ["Fisher-Yates shuffle" mold fisher-yates-shuffle copy v   ]
