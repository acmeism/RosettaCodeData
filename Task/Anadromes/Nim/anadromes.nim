import std/[sets, strutils]

func reversed(s: string): string =
  ## Return the reverse of a string.
  ## Works only for ASCII strings.
  result.setLen(s.len)
  for i in 1..s.len:
    result[i - 1] = s[^i]

var wordSet: OrderedSet[string]
for word in lines("words.txt"):
  if word.len > 6:
    wordSet.incl word

for word in wordSet:
  let rev = reversed(word)
  if rev > word and rev in wordSet:
    echo word.alignLeft(12), rev
