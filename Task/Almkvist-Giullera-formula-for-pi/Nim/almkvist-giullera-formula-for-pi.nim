import strformat, strutils
import decimal

proc fact(n: int): DecimalType =
  result = newDecimal(1)
  if n < 2: return
  for i in 2..n:
    result *= i

proc almkvistGiullera(n: int): DecimalType =
  ## Return the integer portion of the nth term of Almkvist-Giullera sequence.
  let t1 = fact(6 * n) * 32
  let t2 = 532 * n * n + 126 * n + 9
  let t3 = fact(n) ^ 6 * 3
  result = t1 * t2 / t3

let One = newDecimal(1)

setPrec(78)
echo "N                               Integer portion"
echo repeat('-', 47)
for n in 0..9:
  echo &"{n}  {almkvistGiullera(n):>44}"
echo()

echo "Pi to 70 decimal places:"
var
  sum = newDecimal(0)
  prev = newDecimal(0)
  prec = One.scaleb(newDecimal(-70))
  n = 0
while true:
  sum += almkvistGiullera(n) / One.scaleb(newDecimal(6 * n + 3))
  if abs(sum - prev) < prec: break
  prev = sum.clone
  inc n
let pi = 1 / sqrt(sum)
echo ($pi)[0..71]
