proc quickSort[T](a: var openarray[T], inl = 0, inr = -1) =
  var r = if inr >= 0: inr else: a.high
  var l = inl
  let n = r - l + 1
  if n < 2: return
  let p = a[l + 3 * n div 4]
  while l <= r:
    if a[l] < p:
      inc l
      continue
    if a[r] > p:
      dec r
      continue
    if l <= r:
      swap a[l], a[r]
      inc l
      dec r
  quickSort(a, inl, r)
  quickSort(a, l, inr)

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
quickSort a
echo a
