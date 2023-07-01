import strformat
import bignum

type PExp = tuple[prime: Int; exp: uint]

let
  one = newInt(1)
  two = newInt(2)
  ten = newInt(10)


func sqrt(n: Int): Int =
  var s = n
  while true:
    result = s
    s = (n div result + result) shr 1
    if s >= result: break


proc factor(n: Int): seq[PExp] =
  var n = n
  var e = 0u
  while n.bit(e) == 0: inc e
  if e != 0:
    n = n shr e
    result.add (two, e)
  var s = sqrt(n)
  var d = newInt(3)
  while n > one:
    if d > s: d = n
    e = 0u
    while true:
      let (q, r) = divMod(n, d)
      if not r.isZero: break
      n = q
      inc e
    if e != 0:
      result.add (d.clone, e)
      s = sqrt(n)
    inc d, two


proc moBachShallit58(a, n: Int; pf: seq[PExp]): Int =
  let n = abs(n)
  let n1 = n - one
  result = newInt(1)
  for pe in pf:
    let y = n1 div pe.prime.pow(pe.exp)
    var o = 0u
    var x = a.exp(y.toInt.uint, n)
    while x > one:
      x = x.exp(pe.prime.toInt.uint, n)
      inc o
    var o1 = pe.prime.pow(o)
    o1 = o1 div gcd(result, o1)
    result *= o1


proc moTest(a, n: Int) =
  if n.probablyPrime(25) == 0:
    echo "Not computed. Modulus must be prime for this algorithm."
    return

  stdout.write if a.bitLen < 100: &"ord({a})" else: "ord([big])"
  stdout.write if n.bitlen < 100: &" mod {n}" else: " mod [big]"
  let mob = moBachShallit58(a, n, factor(n - one))
  echo &" = {mob}"


when isMainModule:
  moTest(newInt(37), newInt(3343))

  var b = ten.pow(100) + one
  motest(b, newInt(7919))

  b = ten.pow(1000) + one
  moTest(b, newInt("15485863"))

  b = ten.pow(10000) - one
  moTest(b, newInt("22801763489"))

  moTest(newInt("1511678068"), newInt("7379191741"))

  moTest(newInt("3047753288"), newInt("2257683301"))
