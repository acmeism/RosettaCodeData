import strutils

const DictFile = "unixdict.txt"

func isSorted(s: string): bool =
  var last = char.low
  for c in s:
    if c < last: return false
    last = c
  result = true

var
  mx = 0
  words: seq[string]

for word in DictFile.lines:
  if word.len >= mx and word.isSorted:
    if word.len > mx:
      words.setLen(0)
      mx = word.len
    words.add word
echo words.join(" ")
