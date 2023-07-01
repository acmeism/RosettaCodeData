import strutils, sequtils, sets, algorithm

proc reversed(s: string): string =
  result = newString(s.len)
  for i, c in s:
    result[s.high - i] = c

let
  words = readFile("unixdict.txt").strip().splitLines()
  wordset = words.toHashSet
  revs = words.map(reversed)
var pairs = zip(words, revs).filterIt(it[0] < it[1] and it[1] in wordset)

echo "Total number of semordnilaps: ", pairs.len
pairs = pairs.sortedByIt(it[0].len)
echo pairs[^5..^1]
