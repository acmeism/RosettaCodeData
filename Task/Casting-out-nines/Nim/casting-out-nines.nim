import sequtils

iterator castOut(base = 10, start = 1, ending = 999_999) =
  var ran: seq[int] = @[]
  for y in 0 .. <base-1:
    if y mod (base - 1) == (y*y) mod (base - 1):
      ran.add(y)

  var x = start div (base - 1)
  var y = start mod (base - 1)

  block outer:
    while true:
      for n in ran:
        let k = (base - 1) * x + n
        if k < start:
          continue
        if k > ending:
          break outer
        yield k
      inc x

echo toSeq(castOut(base=16, start=1, ending=255))
