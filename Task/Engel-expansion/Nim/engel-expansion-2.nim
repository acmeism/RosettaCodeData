import std/strutils
import bignum

func engel(x: Rat): seq[Int] =
  ## Return the Engel expansion of rational "x".
  var u = x
  while u.num != 0:
    let a = (u.denom + u.num - 1) div u.num
    result.add a
    u = u * a - 1

func toRat(s: string): Rat =
  ## Convert the string representation of a real to a rational.
  var num = newInt(0)
  var den = newInt(1)
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
  result = newRat(num, den)

for val in ["3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211",
            "2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642743",
            "1.4142135623730950488016887242096980785696718753769480731766797379907324784621070388503875343276415727350138462309122970249248360558507372126441214970999358314132226659275055927558"]:
  let e = engel(val.toRat)
  echo "Value: ", val
  echo "Engel expansion: ", e[0..29].join(" ")
  echo "Number of terms: ", e.len
  echo()
