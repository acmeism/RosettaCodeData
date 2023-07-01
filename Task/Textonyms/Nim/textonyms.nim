import algorithm, sequtils, strformat, strutils, tables

const

  WordList = "unixdict.txt"
  Url = "http://www.puzzlers.org/pub/wordlists/unixdict.txt"

  Digits = "22233344455566677778889999"

proc processList(wordFile: string) =

  var mapping: Table[string, seq[string]]
  var countValid = 0

  for word in wordFile.lines:
    var valid = true
    var key: string
    for c in word.toLowerAscii:
      if c notin 'a'..'z':
        valid = false
        break
      key.add Digits[ord(c) - ord('a')]
    if valid:
      inc countValid
      mapping.mgetOrPut(key, @[]).add word

  let textonyms = toSeq(mapping.pairs).filterIt(it[1].len > 1)
  echo &"There are {countValid} words in '{Url}' ",
       &"which can be represented by the digit key mapping."
  echo &"They require {mapping.len} digit combinations to represent them."
  echo &"{textonyms.len} digit combinations represent Textonyms.\n"

  let longest = textonyms.sortedByIt(-it[0].len)
  let ambiguous = longest.sortedByIt(-it[1].len)
  echo "Top 8 in ambiguity:\n"
  echo "Count   Textonym  Words"
  echo "======  ========  ====="
  for a in ambiguous[0..7]:
    echo &"""{a[1].len:4}    {a[0]:>8}  {a[1].join(", ")}"""

  echo "\nTop 6 in length:\n"
  echo "Length  Textonym        Words"
  echo "======  ==============  ====="
  for l in longest[0..5]:
    echo &"""{l[0].len:4}    {l[0]:>14}  {l[1].join(", ")}"""

processList(WordList)
