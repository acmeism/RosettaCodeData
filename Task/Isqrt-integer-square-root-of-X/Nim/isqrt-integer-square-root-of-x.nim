import strformat, strutils
import bignum


func isqrt*[T: SomeSignedInt | Int](x: T): T =
  ## Compute integer square root for signed integers
  ## and for big integers.

  when T is Int:
    result = newInt()
    var q = newInt(1)
  else:
    result = 0
    var q = T(1)

  while q <= x:
    q = q shl 2

  var z = x
  while q > 1:
    q = q shr 2
    let t = z - result - q
    result = result shr 1
    if t >= 0:
      z = t
      result += q


when isMainModule:

  echo "Integer square root for numbers 0 to 65:"
  for n in 0..65:
    stdout.write ' ', isqrt(n)
  echo "\n"

  echo "Integer square roots of odd powers of 7 from 7^1 to 7^73:"
  echo " n" & repeat(' ', 82) & "7^n" & repeat(' ', 34) & "isqrt(7^n)"
  echo repeat("—", 131)

  var x = newInt(7)
  for n in countup(1, 73, 2):
    echo &"{n:>2}   {insertSep($x, ','):>82}   {insertSep($isqrt(x), ','):>41}"
    x *= 49
