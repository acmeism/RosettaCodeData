import std/[algorithm, math, sequtils, strformat, strutils, tables]

const Max = if sizeof(int) == 8: 20 else: 12

type Decomposition = CountTable[int]

const Superscripts: array['0'..'9', string] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]

func superscript(n: Natural): string =
  ## Return the Unicode string to use to represent an exponent.
  if n == 1:
    return ""
  for d in $n:
    result.add Superscripts[d]

proc `$`(d: Decomposition): string =
  ## Return the representation of a decomposition.
  for (value, count) in sorted(d.pairs.toSeq, Descending):
    result.add &"({value}!){superscript(count)}"


# List of Jordan-Pólya numbers and their decomposition.
var jordanPolya = @[1]
var decomposition: Table[int, CountTable[int]] = {1: initCountTable[int]()}.toTable

# Build the list and the decompositions.
for m in 2..Max:                  # Loop on each factorial.
  let f = fac(m)
  for k in 0..jordanPolya.high:   # Loop on existing elements.
    var n = jordanPolya[k]
    while n <= int.high div f:    # Multiply by successive powers of n!
      let p = n
      n *= f
      jordanPolya.add n
      decomposition[n] = decomposition[p]
      decomposition[n].inc(m)

# Sort the numbers and remove duplicates.
jordanPolya = sorted(jordanPolya).deduplicate(true)

echo "First 50 Jordan-Pólya numbers:"
for i in 0..<50:
  stdout.write &"{jordanPolya[i]:>4}"
  stdout.write if i mod 10 == 9: '\n' else: ' '

echo "\nLargest Jordan-Pólya number less than 100 million: ",
     insertSep($jordanPolya[jordanPolya.upperBound(100_000_000) - 1])

for i in [800, 1800, 2800, 3800]:
  let n = jordanPolya[i - 1]
  var d = decomposition[n]
  echo &"\nThe {i}th Jordan-Pólya number is:"
  echo &"{insertSep($n)} = {d}"
