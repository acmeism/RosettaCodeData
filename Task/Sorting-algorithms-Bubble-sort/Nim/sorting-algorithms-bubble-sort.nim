proc bubbleSort[T](a: var openarray[T]) =
  var t = true
  for n in countdown(a.len-2, 0):
    if not t: break
    t = false
    for j in 0..n:
      if a[j] <= a[j+1]: continue
      swap a[j], a[j+1]
      t = true

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
bubbleSort a
echo a
