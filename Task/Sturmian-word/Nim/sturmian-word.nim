import std/[lenientops, math, strformat, strutils]

proc sturmianWord(m, n: Positive): string =
  if m > n:
    return sturmianWord(n, m).multiReplace(("0", "1"), ("1", "0"))
  var (k, prev) = (1, 0)
  while k * m mod n > 0:
    let curr = (k * m) div n
    result.add if curr == prev: "0" else: "10"
    prev = curr
    inc k


proc fibWord(n: Positive): string =
  var prev = "0"
  result = "01"
  for _ in 2..n:
    swap prev, result
    result = prev & result

const Fib = fibWord(7)
const Sturmian = sturmianWord(13, 21)
doAssert Fib[0..Sturmian.high] == Sturmian
echo &"{Sturmian} <== 13/21"


proc cfck(a, b, m, n, k: int): tuple[nom, denom: Natural] =
  var p = @[0, 1]
  var q = @[1, 0]
  var r = (sqrt(a.toFloat) * b + m) / n
  for _ in 1..k:
    let whole = int(r)
    let pn = whole * p[^1] + p[^2]
    let qn = whole * q[^1] + q[^2]
    p.add pn
    q.add qn
    r = 1 / (r - whole)
  result = (p[^1], q[^1])

let (m, n) = cfck(5, 1, -1, 2, 8)
echo &"{sturmianWord(m, n)} <== 1/phi (8th convergent golden ratio)"
