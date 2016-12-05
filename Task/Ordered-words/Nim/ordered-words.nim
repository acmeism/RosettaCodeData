import httpclient, strutils

proc isSorted(s): bool =
  var last = low(char)
  for c in s:
    if c < last:
      return false
    last = c
  return true

const url = "http://www.puzzlers.org/pub/wordlists/unixdict.txt"
var mx = 0
var words: seq[string] = @[]

for word in getContent(url).split():
  if word.len >= mx and isSorted(word):
    if word.len > mx:
      words = @[]
      mx = word.len
    words.add(word)
echo words.join(" ")
