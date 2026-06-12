import bignum

proc root(x: Int; n: int): Int =
  if x < 2: return x
  let n1 = (n - 1).culong
  var c = newInt(1)
  var d = (n1 + x) div n
  var e = (n1 * d + x div d.pow(n1)) div n
  while c != d and c != e:
    c = d
    d = e
    e = (n1 * e + x div e.pow(n1)) div n
  result = if d < e: d else: e


var x: Int
x = newInt(8)
echo "3rd integer root of 8 = ", x.root(3)
x = newInt(9)
echo "3rd integer root of 9 = ", x.root(3)
x = newInt(100).pow(2000) * newInt(2)
echo "First 2001 digits of the square root of 2:"
let s = $x.root(2)
for i in countup(0, s.high, 87): echo s.substr(i, i + 86)
