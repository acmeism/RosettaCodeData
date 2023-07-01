import strformat, strutils
import decimal

setPrec(75)
let pi = newDecimal("3.1415926535897932384626433832795028841971693993751058209749445923078164")

proc eval(n: int): DecimalType =
  result = exp(pi * sqrt(newDecimal(n)))

func format(n: DecimalType; d: Positive): string =
  ## Return the representation of "n" with "d" digits of precision.
  let parts = ($n).split('.')
  result = parts[0] & '.' & parts[1][0..<d]


echo "Ramanujan’s constant with 50 digits of precision:"
echo eval(163).format(50)

setPrec(50)
echo()
echo "Heegner numbers yielding 'almost' integers:"
for n in [19, 43, 67, 163]:
  let x = eval(n)
  let k = x.roundToInt
  let d = x - k
  let s = if d > 0: "+ " & $d else: "- " & $(-d)
  echo &"{n:3}: {x}... = {k:>18} {s}..."
