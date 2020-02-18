import math, strformat

proc legendreIn(x: float, n: int): float =

  template prev1(idx: int; pn1: float): float =
    (2*idx - 1).float * x * pn1

  template prev2(idx: int; pn2: float): float =
    (idx-1).float * pn2

  if n == 0:
    return 1.0
  elif n == 1:
    return x
  else:
    var
      p1 = float x
      p2 = 1.0
    for i in 2 .. n:
      result = (i.prev1(p1) - i.prev2(p2)) / i.float
      p2 = p1
      p1 = result

proc deriveLegendreIn(x: float, n: int): float =
  template calcresult(curr, prev: float): untyped =
    n.float / (x^2 - 1) * (x * curr - prev)
  result = calcresult(x.legendreIn n, x.legendreIn(n-1))

func guess(n, i: int): float =
  cos(PI * (i.float - 0.25) / (n.float + 0.5))

proc nodes(n: int): seq[(float, float)] =
  result = newseq[(float, float)](n)
  template calc(x: float): untyped =
    x.legendreIn(n) / x.deriveLegendreIn(n)

  for i in 0 .. result.high:
    var x = guess(n, i+1)
    block newton:
      var x0 = x
      x -= calc x
      while abs(x-x0) > 1e-12:
        x0 = x
        x -= calc x

    result[i][0] = x
    result[i][1] = 2 / ((1.0 - x^2) * (x.deriveLegendreIn n)^2)

proc integ(f: proc(x: float): float; ns, p1, p2: int): float =
  template dist: untyped =
    (p2 - p1).float / 2.0
  template avg: untyped =
    (p1 + p2).float / 2.0
  result = dist()
  var
    sum = 0'f
    thenodes = newseq[float](ns)
    weights = newseq[float](ns)
  for i, nw in ns.nodes:
    sum += nw[1] * f(dist() * nw[0] + avg())
    thenodes[i] = nw[0]
    weights[i] = nw[1]

  let apos = ":"
  stdout.write fmt"""{"nodes":>8}{apos}"""
  for n in thenodes:
    stdout.write &" {n:>6.5f}"
  stdout.write "\n"
  stdout.write &"""{"weights":>8}{apos}"""
  for w in weights:
    stdout.write &" {w:>6.5f}"
  stdout.write "\n"
  result *= sum

proc main =
  echo "integral: ", integ(exp, 5, -3, 3)

main()
