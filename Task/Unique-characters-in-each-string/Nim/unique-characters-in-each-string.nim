import strutils,  tables

var result = AllChars
for str in ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]:
  let charCount = str.toCountTable      # Mapping char -> count.
  var uniqueChars: set[char]            # Set of unique chars.
  for ch, count in charCount.pairs:
    if count == 1: uniqueChars.incl ch
  result = result * uniqueChars         # Intersection.

echo result
