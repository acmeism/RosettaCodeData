import algorithm, sequtils

const PrimeDigits = [2, 3, 5, 7]

type
  Digit = 0..9
  DigitSeq = seq[Digit]

func toInt(s: DigitSeq): int =
  ## Convert a sequence of digits to an int.
  for d in s:
    result = 10 * result + d


proc findStrangeNumbers(ndigits: Positive): seq[int] =
  ## Return the list of strange numbers with "ndigits" digits.
  var list: seq[DigitSeq] = toSeq(1..9).mapIt(@[Digit it])  # Starting digits.
  for _ in 2..ndigits:
    var newList: seq[DigitSeq]  # List with one more digit.
    for dseq in list:
      let last = dseq[^1]
      for p in PrimeDigits:
        if last - p >= 0:
          newList.add dseq & (last - p)
        if last + p <= 9:
          newList.add dseq & (last + p)
    list = move(newList)    # "newList" becomes the current list.
  result = list.map(toInt)


var result = sorted(findStrangeNumbers(3).filterIt(it < 500))
echo "Found ", result.len, " strange numbers between 101 and 499."
for i, n in result:
  stdout.write n, if (i + 1) mod 15 == 0: '\n' else: ' '
echo()

result = findStrangeNumbers(10).filterIt(it div 1_000_000_000 == 1)
echo "\nFound ", result.len, " strange numbers with 10 digits and starting with 1."
