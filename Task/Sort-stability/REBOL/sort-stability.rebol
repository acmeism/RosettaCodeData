; REBOL's sort function is not stable by default. You need to use a custom comparator to make it so.

blk: [
    [UK London]
    [US New-York]
    [US Birmingham]
    [UK Birmingham]
]
sort/compare blk func [a b] [either a/2 < b/2 [-1] [either a/2 > b/2 [1] [0]]]

; Note that you can also do a stable sort without nested blocks.
blk: [
    UK London
    US New-York
    US Birmingham
    UK Birmingham
]
sort/skip/compare blk 2 func [a b] [either a < b [-1] [either a > b [1] [0]]]
