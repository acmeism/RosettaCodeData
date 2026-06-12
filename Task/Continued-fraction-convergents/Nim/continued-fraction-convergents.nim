import std/[math, strutils]

proc convergents(x: float; maxCount: int): seq[string] =

  const Epsilon = 1e-9
  var x = x
  var components: seq[int]
  for _ in 1..maxCount:
    let (ipart, fpart) = x.splitDecimal()
    components.add ipart.toInt
    if abs(fpart) < Epsilon: break
    x = 1 / fpart

  var (numa, denoma) = (0, 1)
  var (numb, denomb) = (1, 0)
  for comp in components:
    swap numa, numb
    swap denoma, denomb
    numb += comp * numa
    denomb += comp * denoma
    result.add if denomb == 1: $numb else: $numb & '/' & $denomb

when isMainModule:

  const Tests = [("415/93", 415 / 93),
                 ("649/200", 649 / 200),
                 ("sqrt(2)", 2.0 ^ 0.5),
                 ("sqrt(5)", 5.0 ^ 0.5),
                 ("golden ratio", (5.0 ^ 0.5 + 1) / 2)]

  echo "The continued fraction convergents for the following (maximum 8 terms) are:"
  for (s, x) in Tests:
    echo s.align(15), " = ", convergents(x, 8).join(" ")
