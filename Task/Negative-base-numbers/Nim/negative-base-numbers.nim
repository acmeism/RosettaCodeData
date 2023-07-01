import algorithm, sugar, tables

const
  Digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  Values = collect(initTable):
             for i, c in Digits: {c: i}   # Maps the digits to their values in base 10.

type Number = object
  ## Representation of a number in any base.
  base: int
  value: string

func toBase(n, base: int): Number =
  ## Convert an integer into a number in base 'base'.
  assert base notin -1..1, "wrong value for base: " & $base
  if n == 0: return Number(base: base, value: "0")
  result.base = base
  var n = n
  while n != 0:
    var m = n mod base
    n = n div base
    if m < 0:
      inc m, abs(base)
      inc n
    result.value.add Digits[m]
  result.value.reverse()

func `$`(n: Number): string =
  ## String representation of a number.
  $n.value

func toInt(n: Number): int =
  ## Convert a number in some base into an integer in base 10.
  for d in n.value:
    result = n.base * result + Values[d]


when isMainModule:

  proc process(n, base: int) =
    let s = n.toBase(base)
    echo "The value ", n, " is encoded in base ", base, " as: ", s
    echo "and is decoded back in base 10 as: ", s.toInt
    echo ""

process(10, -2)
process(146, -3)
process(15, -10)

const Nim = Number(base: -62, value: "Nim")
echo "The string “Nim” is decoded from base -62 to base 10 as: ", Nim.toInt
