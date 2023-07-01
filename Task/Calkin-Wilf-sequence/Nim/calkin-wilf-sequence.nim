type Fraction = tuple[num, den: uint32]

iterator calkinWilf(): Fraction =
  ## Yield the successive values of the sequence.
  var n, d = 1u32
  yield (n, d)
  while true:
    n = 2 * (n div d) * d + d - n
    swap n, d
    yield (n, d)

proc `$`(fract: Fraction): string =
  ## Return the representation of a fraction.
  $fract.num & '/' & $fract.den

func `==`(a, b: Fraction): bool {.inline.} =
  ## Compare two fractions. Slightly faster than comparison of tuples.
  a.num == b.num and a.den == b.den

when isMainModule:

  echo "The first 20 terms of the Calkwin-Wilf sequence are:"
  var count = 0
  for an in calkinWilf():
    inc count
    stdout.write $an & ' '
    if count == 20: break
  stdout.write '\n'

  const Target: Fraction = (83116u32, 51639u32)
  var index = 0
  for an in calkinWilf():
    inc index
    if an == Target: break
  echo "\nThe element ", $Target, " is at position ", $index, " in the sequence."
