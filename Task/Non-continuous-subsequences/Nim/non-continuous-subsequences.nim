import sequtils

proc ncsub[T](se: seq[T], s = 0): seq[seq[T]] =
  result = @[]
  if se.len > 0:
    let
      x = se[0..0]
      xs = se[1 .. ^1]
      p2 = s mod 2
      p1 = (s + 1) mod 2
    for ys in ncsub(xs, s + p1):
      result.add(x & ys)
    result.add(ncsub(xs, s + p2))
  elif s >= 3:
    result.add(@[])

echo "ncsub(", toSeq 1.. 3, ") = ", ncsub(toSeq 1..3)
echo "ncsub(", toSeq 1.. 4, ") = ", ncsub(toSeq 1..4)
echo "ncsub(", toSeq 1.. 5, ") = ", ncsub(toSeq 1..5)
