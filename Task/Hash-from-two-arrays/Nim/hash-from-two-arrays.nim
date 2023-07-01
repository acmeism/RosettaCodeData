import tables, sequtils

let keys = @['a','b','c']
let values = @[1, 2, 3]

let table = toTable zip(keys, values)
