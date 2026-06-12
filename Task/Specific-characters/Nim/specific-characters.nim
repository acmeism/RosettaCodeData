from strutils import count, join
from sequtils import deduplicate

proc specific(s: openarray[string]): (seq[int], seq[int]) =
  var
    countedChars: set[char]
    all = s.join()

  for word in s:
    var
      specificChars = 0
      uniqueChars = word.deduplicate()

    for character in uniqueChars:
      if word.count(character) == 2 and all.count(character) == 2:
        specificChars += (if character notin countedChars: 1 else: 0)
        countedChars.incl(character)

    result[0].add(specificChars)
    result[1].add(uniqueChars.len() - specificChars)

echo specific(@["ahwiueshaiu", "ajxxfioaaf", "ajrdsfroiwr"])
