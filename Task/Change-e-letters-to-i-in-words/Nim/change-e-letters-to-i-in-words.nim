import sets, strutils, sugar

# Build a set of words to speed up membership check.
let wordSet = collect(initHashSet, for word in "unixdict.txt".lines: {word})

for word in "unixdict.txt".lines:
  let newWord = word.replace('e', 'i')
  if newWord.len > 5 and newWord != word and newWord in wordSet:
    echo word, " → ", newWord
