import sets, strformat, sugar

const DictFile = "unixdict.txt"

let words = collect(initHashSet, for word in DictFile.lines: {word})

var count = 0
for word in DictFile.lines:
  var oddWord: string
  for i in countup(0, word.high, 2): oddWord.add word[i]  # First odd char is at index 0.
  if oddWord.len > 4 and oddWord in words:
    inc count
    echo &"{count:2}: {word:12} →  {oddWord}"
