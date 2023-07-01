template trySwap(): untyped =
  if a[i] < a[i-1]:
    swap a[i], a[i-1]
    t = false

proc cocktailSort[T](a: var openarray[T]) =
  var t = false
  var l = a.len
  while not t:
    t = true
    for i in 1 ..< l: trySwap
    if t: break
    for i in countdown(l-1, 1): trySwap

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
cocktailSort a
echo a
