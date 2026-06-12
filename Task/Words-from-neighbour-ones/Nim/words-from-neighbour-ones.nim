import sets, strutils, sugar

# Build list and set of words with length >= 9.
let words = collect(newSeq):
              for word in "unixdict.txt".lines:
                if word.len >= 9: word
let wordSet = words.toHashSet

var lastWord = ""
var newWord = newString(9)
var count = 0
for i in 0..words.high-9:
  for j in 0..8: newWord[j] = words[i+j][j]
  if newWord in wordSet:
    if newWord != lastWord:
      inc count
      echo ($count).align(2), ' ', newWord
      lastWord = newWord
