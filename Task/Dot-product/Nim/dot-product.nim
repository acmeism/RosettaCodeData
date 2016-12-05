# Compile time error when a and b are differently sized arrays
# Runtime error when a and b are differently sized seqs
proc dotp[T](a,b: T): int =
  assert a.len == b.len
  for i in a.low..a.high:
    result += a[i] * b[i]

echo dotp([1,3,-5], [4,-2,-1])
echo dotp(@[1,2,3],@[4,5,6])
