median: func [
    "Returns the midpoint value in a series of numbers; half the values are above, half are below."
    block [any-block!]
    /local len mid
][
    if empty? block [return none]
    block: sort copy block
    len: length? block
    mid: to integer! len / 2
    either odd? len [
        pick block add 1 mid
    ][
        (block/:mid) + (pick block add 1 mid) / 2
    ]
]
