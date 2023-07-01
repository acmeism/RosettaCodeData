proc gnomeSort[T](a: var openarray[T]) =
  var
    n = a.len
    i = 1
    j = 2
  while i < n:
    if a[i-1] > a[i]:
      swap a[i-1], a[i]
      dec i
      if i > 0: continue
    i = j
    inc j

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
gnomeSort a
echo a
