import std/[math, unicode]

func magicConstant(n: int): int =
  ## Return the magic constant for a magic square of order "n".
  n * (n * n + 1) div 2

func minOrder(n: int): int =
  ## Return the smallest order such as the magic constant is greater than "10^n".
  const Ln2 = ln(2.0)
  const Ln10 = ln(10.0)
  result = int(exp((Ln2 + n.toFloat * Ln10) / 3)) + 1

const First = 3
const Superscripts: array['0'..'9', string] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]

template order(idx: Positive): int =
  ## Compute the order of the magic square at index "idx".
  idx + (First - 1)

func superscript(n: Natural): string =
  ## Return the Unicode string to use to represent an exponent.
  for d in $n:
    result.add(Superscripts[d])

echo "First 20 magic constants:"
for idx in 1..20:
  stdout.write ' ', order(idx).magicConstant
echo()

echo "\n1000th magic constant: ", order(1000).magicConstant

echo "\nOrder of the smallest magic square whose constant is greater than:"
for n in 1..20:
  let left = "10" & n.superscript & ':'
  echo left.alignLeft(6), ($minOrder(n)).align(7)
