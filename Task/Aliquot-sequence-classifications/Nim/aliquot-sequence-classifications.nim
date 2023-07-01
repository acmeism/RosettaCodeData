import std/[math, strformat, times]
from std/strutils import addSep

type

  # Classification categories.
  Category {.pure.} = enum
    Unknown
    Terminating = "terminating"
    Perfect = "perfect"
    Amicable = "amicable"
    Sociable = "sociable"
    Aspiring = "aspiring"
    Cyclic = "cyclic"
    NonTerminating = "non-terminating"

  # Aliquot sequence.
  AliquotSeq = seq[int64]

const Limit = 2^47    # Limit beyond which the category is considered to be "NonTerminating".

#---------------------------------------------------------------------------------------------------

proc sumProperDivisors(n: int64): int64 =
  ## Compute the sum of proper divisors.*

  if n == 1: return 0
  result = 1
  for d in 2..sqrt(n.float).int:
    if n mod d == 0:
      inc result, d
      if n div d != d:
        result += n div d

#---------------------------------------------------------------------------------------------------

iterator aliquotSeq(n: int64): int64 =
  ## Yield the elements of the aliquot sequence of "n".
  ## Stopped if the current value is null or equal to "n".

  var k = n
  while true:
    k = sumProperDivisors(k)
    yield k

#---------------------------------------------------------------------------------------------------

proc `$`(a: AliquotSeq): string =
  ## Return the representation of an allquot sequence.

  for n in a:
    result.addSep(", ", 0)
    result.addInt(n)

#---------------------------------------------------------------------------------------------------

proc classification(n: int64): tuple[cat: Category, values: AliquotSeq] =
  ## Return the category of the aliquot sequence of a number "n" and the sequence itself.

  var count = 0         # Number of elements currently generated.
  var prev = n          # Previous element in the sequence.
  result.cat = Unknown
  for k in aliquotSeq(n):
    inc count
    if k == 0:
      result.cat = Terminating
    elif k == n:
      result.cat = case count
                   of 1: Perfect
                   of 2: Amicable
                   else: Sociable
    elif k > Limit or count > 16:
      result.cat = NonTerminating
    elif k == prev:
      result.cat = Aspiring
    elif k in result.values:
      result.cat = Cyclic
    prev = k
    result.values.add(k)
    if result.cat != Unknown:
      break

#---------------------------------------------------------------------------------------------------

let t0 = getTime()

for n in 1..10:
  let (cat, aseq) = classification(n)
  echo fmt"{n:14}:  {cat:<20} {aseq}"

echo ""
for n in [int64 11, 12, 28, 496, 220, 1184, 12496, 1264460,
                790, 909, 562, 1064, 1488, 15355717786080]:
  let (cat, aseq) = classification(n)
  echo fmt"{n:14}:  {cat:<20} {aseq}"

echo ""
echo fmt"Processed in {(getTime() - t0).inMilliseconds} ms."
