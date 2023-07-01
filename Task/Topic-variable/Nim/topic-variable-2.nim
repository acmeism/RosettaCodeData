import sequtils
let x = [1, 2, 3, 4, 5]
let y = x.mapIt(it * it)
echo y    # @[1, 4, 9, 16, 25]
