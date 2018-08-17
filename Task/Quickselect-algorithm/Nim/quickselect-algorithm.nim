proc qselect[T](a: var openarray[T]; k: int, inl = 0, inr = -1): T =
  var r = if inr >= 0: inr else: a.high
  var st = 0
  for i in 0 ..< r:
    if a[i] > a[r]: continue
    swap a[i], a[st]
    inc st

  swap a[r], a[st]

  if k == st:  a[st]
  elif st > k: qselect(a, k, 0, st - 1)
  else:        qselect(a, k, st, inr)

let x = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]

for i in 0..9:
  var y = x
  echo i, ": ", qselect(y, i)
