import algorithm, math, random, sequtils, strutils, unicode

# Representation of a factorial base number with N digits.
type FactorialBaseNumber[N: static Positive] = array[N, int]

#---------------------------------------------------------------------------------------------------

func permutation[T](elements: openArray[T]; n: FactorialBaseNumber): seq[T] =
  ## Return the permutation of "elements" associated to the factorial base number "n".
  result = @elements
  for m, g in n:
    if g > 0:
      result.rotateLeft(m.int..(m + g), -1)

#---------------------------------------------------------------------------------------------------

func incr(n: var FactorialBaseNumber): bool =
  ## Increment a factorial base number.
  ## Return false if an overflow occurred.
  var base = 1
  var k = 1
  for i in countdown(n.high, 0):
    inc base
    inc n[i], k
    if n[i] >= base:
      n[i] = 0
      k = 1
    else:
      k = 0
  result = k == 0

#---------------------------------------------------------------------------------------------------

iterator fbnSeq(n: static Positive): auto =
  ## Yield the successive factorial base numbers of length "n".
  var result: FactorialBaseNumber[n]
  while true:
    yield result
    if not incr(result): break

#---------------------------------------------------------------------------------------------------

func `$`(n: FactorialBaseNumber): string {.inline.} =
  ## Return the string representation of a factorial base number.
  n.join(".")

#———————————————————————————————————————————————————————————————————————————————————————————————————

# Part 1.
echo "Mapping between factorial base numbers and permutations:"
for n in fbnSeq(3):
  echo n, " → ", "0123".permutation(n).join()

# Part 2.
echo ""
echo "Generating the permutations of 11 digits:"
const Target = fac(11)
var count = 0
for n in fbnSeq(10):
  inc count
  let perm = "0123456789A".permutation(n)
  if count in 1..3 or count in (Target - 2)..Target:
    echo n, " → ", perm.join()
  elif count == 4:
    echo "[...]"
echo "Number of permutations generated: ", count
echo "Number of permutations expected:  ", Target

# Part 3.
const
  FBNS = [
    "39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0",
    "51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1"]
  Cards = ["A♠", "K♠", "Q♠", "J♠", "10♠", "9♠", "8♠", "7♠", "6♠", "5♠", "4♠", "3♠", "2♠",
           "A♥", "K♥", "Q♥", "J♥", "10♥", "9♥", "8♥", "7♥", "6♥", "5♥", "4♥", "3♥", "2♥",
           "A♦", "K♦", "Q♦", "J♦", "10♦", "9♦", "8♦", "7♦", "6♦", "5♦", "4♦", "3♦", "2♦",
           "A♣", "K♣", "Q♣", "J♣", "10♣", "9♣", "8♣", "7♣", "6♣", "5♣", "4♣", "3♣", "2♣"]
  M = Cards.len - 1

var fbns: array[3, FactorialBaseNumber[M]]

# Parse the given factorial base numbers.
for i in 0..1:
  for j, n in map(FBNS[i].split('.'), parseInt):
    fbns[i][j] = n

# Generate a random factorial base number.
randomize()
for j in 0..fbns[3].high:
  fbns[2][j] = rand(0..(M - j))

echo ""
echo "Card permutations:"
for i in 0..2:
  echo "– for ", fbns[i], ':'
  echo "  ", Cards.permutation(fbns[i]).join(" ")
