import math, rationals, strformat

type
  Rat = Rational[int]
  Ng = tuple[a1, a, b1, b: int]

const NS = 1 // 1   # Non significant value.


iterator r2cf(rat: Rat): int {.closure.} =
  var
    num = rat.num
    den = rat.den
  for count in 1..20:
    let d = num div den
    num = num mod den
    swap num, den
    yield d
    if den == 0: break


iterator d2cf(f: float): int {.closure.} =
  var f = f
  for count in 1..20:
    let d = floor(f)
    let r = f - d
    yield int(d)
    if r == 0: break
    f = 1 / r


iterator root2(dummy: Rat): int {.closure.} =
  yield 1
  for count in 1..20: yield 2


iterator recipRoot2(rat: Rat): int {.closure.} =
  yield 0
  yield 1
  for count in 1..20: yield 2


func ingress(ng: var Ng; n: int) =
  ng.a += ng.a1 * n
  swap ng.a, ng.a1
  ng.b += ng.b1 * n
  swap ng.b, ng.b1


func egress(ng: var Ng): int =
  let n = ng.a div ng.b
  ng.a -= ng.b * n
  swap ng.a, ng.b
  ng.a1 -= ng.b1 * n
  swap ng.a1, ng.b1
  result = n


func needTerm(ng: Ng): bool = ng.b == 0 or ng.b1 == 0 or (ng.a // ng.b != ng.a1 // ng.b1)


func egressDone(ng: var Ng): int =
  if ng.needTerm:
    ng.a = ng.a1
    ng.b = ng.b1
  result = ng.egress()


func done(ng: Ng): bool = ng.b == 0 or ng.b1 == 0


when isMainModule:

  let data = [("[1;5,2] + 1/2        ", (2, 1, 0, 2), 13 // 11, r2cf),
              ("[3;7] + 1/2          ", (2, 1, 0, 2), 22 // 7,  r2cf),
              ("[3;7] divided by 4   ", (1, 0, 0, 4), 22 // 7,  r2cf),
              ("sqrt(2)              ", (0, 1, 1, 0), NS,  recipRoot2),
              ("1 / sqrt(2)          ", (0, 1, 1, 0), NS,  root2),
              ("(1 + sqrt(2)) / 2    ", (1, 1, 0, 2), NS,  root2),
              ("(1 + 1 / sqrt(2)) / 2", (1, 1, 0, 2), NS,  recipRoot2)]

  echo "Produced by NG object:"
  for (str, ng, r, gen) in data:
    stdout.write &"{str} → "
    var op = ng
    for n in gen(r):
      if not op.needTerm: stdout.write &" {op.egress()} "
      op.ingress(n)
    while true:
      stdout.write &" {op.egressDone} "
      if op.done: break
    echo()

  echo "\nProduced by direct calculation:"
  let data2 = [("(1 + sqrt(2)) / 2    ", (1 + sqrt(2.0)) / 2),
               ("(1 + 1 / sqrt(2)) / 2", (1 + 1 / sqrt(2.0)) / 2)]
  for (str, d) in data2:
    stdout.write &"{str} →"
    for n in d2cf(d): stdout.write "  ", n
    echo()
