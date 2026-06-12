import strutils

func isAbcWord(word: string): bool =
  let ia = word.find('a')
  if ia < 0: return false
  let ib = word.find('b')
  if ib < ia: return false
  let ic = word.find('c')
  if ic < ib: return false
  result = true

var count = 0
for word in "unixdict.txt".lines:
  if word.isAbcWord:
    inc count
    echo ($count).align(2), ' ', word
