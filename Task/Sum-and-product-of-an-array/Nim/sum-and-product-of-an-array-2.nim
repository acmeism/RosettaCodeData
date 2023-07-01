import sequtils

let
  xs = [1, 2, 3, 4, 5, 6]
  sum = xs.foldl(a + b)
  product = xs.foldl(a * b)
