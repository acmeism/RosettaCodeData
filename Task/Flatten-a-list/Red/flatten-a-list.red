flatten: function [
    "Flatten the block"
    block [any-block!]
][
    load form block
]

red>> flatten [[1] 2 [[3 4] 5] [[[]]] [[[6]]] 7 8 []]
== [1 2 3 4 5 6 7 8]

;flatten a list to a string
>> blk: [1 2 ["test"] "a" [["bb"]] 3 4 [[[99]]]]
>> form blk
== "1 2 test a bb 3 4 99"
