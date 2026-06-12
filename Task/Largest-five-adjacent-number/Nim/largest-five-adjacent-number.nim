import random, strutils

randomize()

const N = 1000
type Digit = 0..9

# Build a 1000-digit number.
var number: array[1..N, Digit]
number[1] = rand(1..9)  # Make sure the first digit is not 0.
for i in 1..N: number[i] = rand(9)

func `>`(s1, s2: seq[Digit]): bool =
  ## Compare two digit sequences.
  ## Defining `<` rather than `>` would work too.
  assert s1.len == s2.len
  for i in 0..s1.high:
    let comp = cmp(s1[i], s2[i])
    if comp != 0: return comp == 1
  result = false

var max = @[Digit 0, 0, 0, 0, 0]
for i in 5..N:
  let n = number[i-4..i]
  if n > max: max = n

echo "Largest 5-digit number extracted from random 1000-digit number: ", max.join()
