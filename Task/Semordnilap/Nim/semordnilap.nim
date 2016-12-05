import strutils, sequtils, sets, algorithm

proc reverse(s): string =
  result = newString(s.len)
  for i,c in s:
    result[s.high - i] = c

let
  words = readFile("unixdict.txt").strip.splitLines
  wordset = words.toSet
  revs = words.map(reverse)
var pairs = zip(words, revs).filterIt(it[0] < it[1] and it[1] in wordset)

echo "Total number of semordnilaps: ", pairs.len
pairs.sort(proc (x,y): auto = cmp(x[0].len,y[0].len))
echo pairs[pairs.high-4..pairs.high]
