import sequtils

proc pascal(n: int) =
  var row = @[1]
  for r in 1..n:
    echo row
    row = zip(row & @[0], @[0] & row).mapIt(int, it[0] + it[1])

pascal(10)
