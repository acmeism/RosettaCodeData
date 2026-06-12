import lenientops, math, strformat, sugar

type Cheb = object
  c: seq[float]
  min, max: float


func initCheb(min, max: float; nCoeff, nNodes: int; fn: (float {.noSideEffect.} -> float)): Cheb =

  result = Cheb(c: newSeq[float](nCoeff), min: min, max: max)
  var f, p = newSeq[float](nNodes)
  let z = 0.5 * (max + min)
  let r = 0.5 * (max - min)
  for k in 0..<nNodes:
    p[k] = PI * (k + 0.5) / nNodes
    f[k] = fn(z + cos(p[k]) * r)

  let n2 = 2 / nNodes
  for j in 0..<nCoeff:
    var sum = 0.0
    for k in 0..<nNodes:
      sum += f[k] * cos(j * p[k])
    result.c[j] = sum * n2


func eval(cheb: Cheb; x: float): float =
  let x1 = (2 * x - cheb.min - cheb.max) / (cheb.max - cheb.min)
  let x2 = 2 * x1
  var s, t: float
  for j in countdown(cheb.c.high, 1):
    s = x2 * t - s + cheb.c[j]
    swap s, t
  result = x1 * t - s + 0.5 * cheb.c[0]


when isMainModule:
  let fn: (float {.noSideEffect.} -> float) = cos
  let cheb = initCheb(0, 1, 10, 10, fn)
  echo "Coefficients:"
  for c in cheb.c:
    echo &"{c: .15f}"

  echo "\n x     computed    approximated   computed-approx"
  const N = 10
  for i in 0..N:
    let x = (cheb.min * (N - i) + cheb.max * i) / N
    let computed = fn(x)
    let approx = cheb.eval(x)
    echo &"{x:.1f} {computed:12.8f}  {approx:12.8f}      {computed-approx: .3e}"
