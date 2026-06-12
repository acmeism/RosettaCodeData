import std/[math, rationals, strutils]

type Fract = Rational[int64]

func engel(x: Fract): seq[Natural] =
  ## Return the Engel expansion of rational "x".
  var u = x
  while u.num != 0:
    let a = ceil(u.den.float / u.num.float).toInt
    result.add a
    u = u * a - 1

func toRational(s: string): Fract =
  ## Convert the string representation of a real to a rational
  ## without using an intermediate float representation.
  var num = 0i64
  var den = 1i64
  var i = 0
  var c = s[0]
  while c != '.':
    num = 10 * num + ord(c) - ord('0')
    inc i
    c = s[i]
  inc i
  while i < s.len:
    num = 10 * num + ord(s[i]) - ord('0')
    den *= 10
    inc i
  result = num // den


for val in ["3.14159265358979", "2.71828182845904", "1.414213562373095"]:
  let e = engel(val.toRational)
  echo "Value: ", val
  echo "Engel expansion: ", e.join(" ")
  echo()
