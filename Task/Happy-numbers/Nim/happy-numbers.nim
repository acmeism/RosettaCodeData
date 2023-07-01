import intsets

proc happy(n: int): bool =
  var
    n = n
    past = initIntSet()
  while n != 1:
    let s = $n
    n = 0
    for c in s:
      let i = ord(c) - ord('0')
      n += i * i
    if n in past:
      return false
    past.incl(n)
  return true

for x in 0..31:
  if happy(x):
    echo x
