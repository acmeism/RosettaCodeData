# Runtime error if lengths of arrays or sequences differ.

func dotProduct[T](a, b: openArray[T]): T =
  doAssert a.len == b.len
  for i in 0..a.high:
    result += a[i] * b[i]

echo dotProduct([1,3,-5], [4,-2,-1])
echo dotProduct(@[1,2,3],@[4,5,6])
echo dotProduct([1.0, 2.0, 3.0], @[7.0, 8.0, 9.0])
