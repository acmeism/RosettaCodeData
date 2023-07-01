average: func [
    "Returns the average of all values in a block"
    block [block! vector! paren! hash!]
][
    if empty? block [return none]
    divide sum block to float! length? block
]
