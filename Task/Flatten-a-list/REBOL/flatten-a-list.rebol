flatten: func [
    "Flatten the block in place."
    block [any-block!]
][
    parse block [
        any [block: any-block! (change/part block first block 1) :block | skip]
    ]
    head block
]
