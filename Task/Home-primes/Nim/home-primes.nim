import algorithm, sequtils, strformat, strutils
import bignum

let
  Two = newInt(2)
  Three = newInt(3)
  Five = newInt(5)


proc primeFactorsWheel(n: Int): seq[Int] =
  const Inc = [4, 2, 4, 2, 4, 6, 2, 6]
  var n = n
  while (n mod 2).isZero:
    result.add Two
    n = n div 2
  while (n mod 3).isZero:
    result.add Three
    n = n div 3
  while (n mod 5).isZero:
    result.add Five
    n = n div 5
  var k = 7
  var i = 0
  while k * k <= n:
    if (n mod k).isZero:
      result.add newInt(k)
      n = n div k
    else:
      inc k, Inc[i]
      i = (i + 1) and 7
  if n > 1: result.add n


func pollardRho(n : Int): Int =

  func g(x, y: Int): Int = (x * x + 1) mod y

  var x, y = newInt(2)
  var z, d = newInt(1)
  var count = 0
  while true:
    x = g(x, n)
    y = g(g(y, n), n)
    d = abs(x - y) mod n
    z *= d
    inc count
    if count == 100:
      d = gcd(z, n)
      if d != 1: break
      z = newInt(1)
      count = 0
  if d == n: return newInt(0)
  result = d


proc primeFactors(n: Int): seq[Int] =
  var n = n
  while n > 1:
    if n > 100_000_000:
      let d = pollardRho(n)
      if not d.isZero:
        result.add primeFactorsWheel(d)
        n = n div d
        if n.probablyPrime(25) != 0:
          result.add n
          break
      else:
        result.add primeFactorsWheel(n)
        break
    else:
      result.add primeFactorsWheel(n)
      break
  result.sort()


let list = toSeq(2..20) & 65
for i in list:
  if i in [2, 3, 5, 7, 11, 13, 17, 19]:
    echo &"HP{i} = {i}"
    continue
  var n = 1
  var j = newInt(i)
  var h = @[j]
  while true:
    j = newInt(primeFactors(j).join())
    h.add j
    if j.probablyPrime(25) != 0:
      for k in countdown(n, 1):
        stdout.write &"HP{h[n-k]}({k}) = "
      echo h[n]
      break
    else:
      inc n
