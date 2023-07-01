-- product of [a,a+1..b]
productFromTo a b =
  if a>b then 1
  else if a == b then a
  else productFromTo a c * productFromTo (c+1) b
  where c = (a+b) `div` 2

factorial = productFromTo 1
