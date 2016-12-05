import sequtils

let values = @[0,1,2,3,4,5,6,7,8,9]

let evens = values.filter(proc (x: int): bool = x mod 2 == 0)

let odds = values.filterIt(it mod 2 == 1)
