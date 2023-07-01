import math, sequtils

proc sumSquares[T: SomeNumber](a: openArray[T]): T =
  sum(a.mapIt(it * it))

let a1 = [1, 2, 3, 4, 5]
echo a1, " → ", sumSquares(a1)

let a2: seq[float] = @[]
echo a2, " → ", sumSquares(a2)
