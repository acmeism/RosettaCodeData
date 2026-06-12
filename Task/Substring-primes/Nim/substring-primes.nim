import sequtils, strutils

type
  Digit = 0..9
  DigitSeq = seq[Digit]


func isOddPrime(n: Positive): bool =
  ## Check if "n" is an odd prime.
  assert n > 10
  var d = 3
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
  return true


func toInt(s: DigitSeq): int =
  ## Convert a sequence of digits to an int.
  for d in s:
    result = 10 * result + d


var result = @[2, 3, 5, 7]
var list: seq[DigitSeq] = result.mapIt(@[Digit it])
var primeTestCount = 0

while list.len != 0:
  var newList: seq[DigitSeq]
  for dseq in list:
    for d in [Digit 3, 7]:
      if dseq[^1] != d:   # New digit must be different of last digit.
        inc primeTestCount
        let newDseq = dseq & d
        let candidate = newDseq.toInt
        if candidate.isOddPrime:
          newList.add newDseq
          result.add candidate
  list = move(newList)

echo "List of substring primes: ", result.join(" ")
echo "Number of primality tests: ", primeTestCount
