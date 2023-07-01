import algorithm, sequtils, strformat, strutils, tables

type

  Digit = range[0..9]
  Number = seq[Digit]                 # Number as a sequence of digits (unit at index 0).

  # Structure used to find the candidates for Lychrel numbers.
  Candidates = object
    seeds: seq[Number]                # List of possible seeds.
    linked: Table[Number, Number]     # Maps a number to a smallest number in a sequence.


####################################################################################################
# Conversions.

func toInt(n: Number): Natural =
  ## Convert a Number to an int. No check is done for overflow.
  for i in countdown(n.high, 0):
    result = 10 * result + n[i]

func `$`(n: Number): string =
  ## Return the string representation of a Number.
  reversed(n).join()

func `$`(s: seq[Number]): string =
  ## Return the string representation of a sequence of Numbers.
  s.mapIt($it).join(" ")


####################################################################################################
# Operations on Numbers.

func addReverse(n: var Number) =
  ## Add a Number to its reverse.
  var carry = 0
  var high = n.high
  var r = reversed(n)
  for i in 0..high:
    var sum = n[i] + r[i] + carry
    if sum >= 10:
      n[i] = sum - 10
      carry = 1
    else:
      n[i] = sum
      carry = 0
  if carry != 0: n.add carry

func inc(a: var Number) =
  ## Increment a Number by one.
  for item in a.mitems:
    let sum = item + 1
    if sum >= 10:
      item = sum - 10
    else:
      item = sum
      return  # No carry: stop adding.
  a.add 1     # Add last carry.


####################################################################################################
# Operations related to Lychrel numbers.

func isPalindromic(n: Number): bool =
  ## Check if a Number is palindromic.
  for i in 0..(n.high div 2):
    if n[i] != n[n.high - i]: return false
  result = true


func isRelatedLychrel(candidates: Candidates; n: Number): bool =
  ## Check if a Number is a Lychrel related number.

  var val = candidates.linked[n]
  # Search for the first value in a list of linked values.
  while val in candidates.linked: val = candidates.linked[val]
  # If the first value is a seed, "n" is related to it.
  result = val in candidates.seeds


func relatedCount(candidates: Candidates; maxlen: Positive): int =
  ## Return the number of related Lychrel numbers with length <= maxlen.

  # Loop on values which are linked to a smallest value.
  for n in candidates.linked.keys:
    if n.len <= maxlen and candidates.isRelatedLychrel(n): inc result


func palindromicLychrel(candidates: Candidates; maxlen: Positive): seq[int] =
  ## Return the list of palindromic Lychrel numbers with length <= maxlen.

  # Search among seed Lychrel numbers.
  for n in candidates.seeds:
    if n.len <= maxlen and n.isPalindromic:
      result.add n.toInt
  # Search among related Lychrel numbers.
  for n in candidates.linked.keys:
    if n.len <= maxlen and n.isPalindromic and candidates.isRelatedLychrel(n):
      result.add n.toInt
  # Sort the whole list.
  result.sort()


proc check(candidates: var Candidates; num: Number) =
  ## Check if a Number is a possible Lychrel number.

  if num in candidates.linked: return   # Already encountered: nothing to do.
  var val = num
  for _ in 1..500:
    val.addReverse()
    if val in candidates.linked:
      # Set the linked value of "num" to that of "val".
      candidates.linked[num] = candidates.linked[val]
      return
    if val.isPalindromic(): return  # Don't store palindromic values as they may be seeds.
    candidates.linked[val] = num
  candidates.seeds.add num


#———————————————————————————————————————————————————————————————————————————————————————————————————

var cand: Candidates

var num: Number = @[Digit(0)]   # The Number to test.
for n in 1..10_000:
  inc num
  cand.check(num)

echo &"Found {cand.seeds.len} candidate seed Lychrel numbers between 1 and 10000."
echo "These candidate seed Lychrel numbers are: ", cand.seeds
echo &"Found {cand.relatedCount(4)} candidate related Lychrel numbers between 1 and 10000."
echo "Palindromic candidate Lychrel numbers between 1 and 10000 are: ", cand.palindromicLychrel(4)
