=> (setv a [1 2 3])
=> a
[1, 2, 3]

=> (+ a [4 5 6]) ; returns the concatenation
[1, 2, 3, 4, 5, 6]
=> a
[1, 2, 3]

=> (.extend a [7 8 9]) ; modifies the list in place
=> a
[1, 2, 3, 7, 8, 9]

=> (+ [1 2] [3 4] [5 6]) ; can accept multiple arguments
[1, 2, 3, 4, 5, 6]
