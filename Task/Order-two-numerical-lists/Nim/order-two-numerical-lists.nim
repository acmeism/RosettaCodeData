proc `<`[T](a, b: openarray[T]): bool =
  for i in 0 .. min(a.len, b.len):
    if a[i] < b[i]: return true
    if a[i] > b[i]: return false
  return a.len < b.len

echo([1,2,1,3,2] < [1,2,0,4,4,0,0,0])
