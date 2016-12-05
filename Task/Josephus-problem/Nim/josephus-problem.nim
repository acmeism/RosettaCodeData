import sequtils, strutils, future

proc j(n, k): string =
  var
    p = toSeq(0 .. < n)
    i = 0
    s = newSeq[int]()

  while p.len > 0:
    i = (i + k - 1) mod p.len
    s.add p[i]
    system.delete(p, i)

  result = "Prisoner killing order: "
  result.add s.map((x: int) => $x).join(", ")
  result.add ".\nSurvivor: "
  result.add($s[s.high])

echo j(5,2)
echo j(41,3)
