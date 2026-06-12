import std/strformat
import bignum

func toDecimal100(r: Rat): string =
  ## Return the representation of a rational up to 100 decimals.
  r *= newInt(10)^100
  result.setLen(102)
  result = ($r.toInt)[0..100]
  result.insert(".", 1)

proc apery(n: Positive) =
  var sum = newRat()
  for k in 1..n:
    sum += newRat(1, k^3)
  echo &"First {n} terms of ζ(3) truncated to 100 decimal places (accurate to 6 decimal places):"
  echo sum.toDecimal100
  echo()

proc markov(n: Positive) =
  var neg = true
  var fact1, fact2 = newInt(1)
  var sum = newRat()
  for k in 1..n:
    neg = not neg
    fact1 *= k
    var num = fact1 * fact1
    if neg: num = -num
    fact2 *= 2 * k * (2 * k - 1)
    let denom = fact2 * k^3
    sum += newRat(num, denom)
  sum *= newRat(5, 2)
  echo &"First {n} terms of Markov / Apéry representation truncated to 100 decimal places:"
  echo sum.toDecimal100
  echo()

proc wedeniwski(n: Positive) =
  var fact1, fact2 = newInt(1)
  var neg = true
  var sum = newRat()
  for k in 0..<n:
    neg = not neg
    if k > 0:
      fact1 *= k
      fact2 *= 2 * k * (2 * k - 1)
    let fact3 = fact2 * (2 * k + 1)
    var num = (fact1 * fact2 * fact3)^3
    num *= ((((126392 * k + 412708) * k + 531578) * k + 336367) * k + 104000) * k + 12463
    if neg: num = -num
    let denom = fac(4 * k + 3)^3 * fac(3 * k + 2)
    sum += newRat(num, denom)
  sum /= 24
  echo &"First {n} terms of Wedeniwski representation truncated to 100 decimal places:"
  echo sum.toDecimal100
  echo()


echo "Actual value to 100 decimal places:"
echo "1.2020569031595942853997381615114499907649862923404988817922715553418382057863130901864558736093352581"
echo()
apery(1000)
markov(158)
wedeniwski(20)
