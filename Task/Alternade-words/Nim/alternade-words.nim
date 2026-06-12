import algorithm, sets, strutils, sugar

proc alternatingWords(word: string): array[2, string] =
  ## Return the candidate alternating words of a word.
  for i, c in word:
    result[i and 1].add c

let words = collect(HashSet, for word in "unixdict.txt".lines: {word})

var result: seq[string]
for word in words:
  if word.len >= 6:
    let altWords = alternatingWords(word)
    if altWords[0] in words and altWords[1] in words:
      result.add word.align(8) & " → $1 $2" % altWords
result.sort()
for i, line in result: echo ($(i+1)).align(2), ": ", line
