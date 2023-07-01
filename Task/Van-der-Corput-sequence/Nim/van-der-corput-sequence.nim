import rationals, strutils, sugar

type Fract = Rational[int]

proc corput(n: int; base: Positive): Fract =
  result = 0.toRational
  var b = 1 // base
  var n = n
  while n != 0:
    result += n mod base * b
    n = n div base
    b /= base

for base in 2..5:
  let list = collect(newSeq, for n in 1..10: corput(n, base))
  echo "Base $#: ".format(base), list.join(" ")
