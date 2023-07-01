import strutils, strformat, tables

####################################################################################################
# Cardinal and ordinal strings.

const

  Small = ["zero",    "one",     "two",       "three",    "four",
           "five",    "six",     "seven",     "eight",    "nine",
           "ten",     "eleven",  "twelve",    "thirteen", "fourteen",
           "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]

  Tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

  Illions = ["", " thousand", " million", " billion", " trillion", " quadrillion", " quintillion"]

  IrregularOrdinals = {"one": "first", "two": "second", "three": "third", "five": "fifth",
                       "eight": "eighth", "nine": "ninth", "twelve": "twelfth"}.toTable()

#---------------------------------------------------------------------------------------------------

func spellCardinal(n: int64): string =
  ## Spell an integer as a cardinal.

  var n = n

  if n < 0:
    result = "negative "
    n = -n

  if n < 20:
    result &= Small[n]

  elif n < 100:
    result &= Tens[n div 10]
    let m = n mod 10
    if m != 0: result &= '-' & Small[m]

  elif n < 1000:
    result &= Small[n div 100] & " hundred"
    let m = n mod 100
    if m != 0: result &= ' ' & m.spellCardinal()

  else:
    # Work from right to left.
    var sx = ""
    var i = 0
    while n > 0:
      let m = n mod 1000
      n = n div 1000
      if m != 0:
        var ix = m.spellCardinal() & Illions[i]
        if sx.len > 0: ix &= " " & sx
        sx = ix
      inc i
    result &= sx

#---------------------------------------------------------------------------------------------------

func spellOrdinal(n: int64): string =
  ## Spell an integer as an ordinal.

  result = n.spellCardinal()
  var parts = result.rsplit({' ', '-'}, maxsplit = 1)
  let tail = parts[^1]
  if tail in IrregularOrdinals:
    result[^tail.len..^1] = IrregularOrdinals[tail]
  elif tail.endsWith('y'):
    result[^1..^1]= "ieth"
  else:
    result &= "th"


####################################################################################################
# Sentence building.

type Sentence = seq[string]

#---------------------------------------------------------------------------------------------------

iterator words(sentence: var Sentence): tuple[idx: int; word: string] =
  ## Yield the successive words of the sentence with their index.

  yield (0, "Four")
  var idx = 1
  var last = 0
  while true:
    yield (idx, sentence[idx])
    inc idx
    if idx == sentence.len:
      inc last
      sentence.add([sentence[last].count(Letters).spellCardinal(), "in", "the"])
      # For the position, we need to split the ordinal as it may contain spaces.
      sentence.add(((last + 1).spellOrdinal() & ',').splitWhitespace())

#---------------------------------------------------------------------------------------------------

iterator letterCounts(sentence: var Sentence): tuple[idx: int; word: string; count: int] =
  ## Secondary iterator used to yield the number of letters in addition to the index and the word.

  for i, word in sentence.words():
    yield (i, word, word.count(Letters))


####################################################################################################
# Drivers.

# Constant to initialize the sentence.
const Init = "Four is the number of letters in the first word of this sentence,".splitWhitespace()

#---------------------------------------------------------------------------------------------------

proc displayLetterCounts(pos: Positive) =
  ## Display the number of letters of the word at position "pos".

  var sentence = Init
  echo fmt"Number of letters in first {pos} words in the sequence:"
  var valcount = 0   # Number of values displayed in the current line.
  var length = 0

  for i, word, letterCount in sentence.letterCounts():
    if i == pos:
      # Terminated.
      dec length  # Adjust space count.
      echo ""
      break

    if valcount == 0: stdout.write fmt"{i+1:>3}:"
    stdout.write fmt"{letterCount:>3}"
    inc valcount
    inc length, word.len + 1  # +1 for space.

    if valcount == 12:
      # Terminate line.
      echo ""
      valcount = 0

  echo fmt"Length of sentence: {length}"

#---------------------------------------------------------------------------------------------------

proc displayWord(pos: Positive) =
  ## Display the word at position "pos".

  var sentence = Init
  let idx = pos - 1
  var length = 0
  for i, word in sentence.words():
    length += word.len + 1
    if i == idx:
      dec length    # Adjust space count.
      let w = word.strip(leading = false, chars = {','})  # Remove trailing ',' if needed.
      echo fmt"Word {pos} is ""{w}"" with {w.count(Letters)} letters."
      echo fmt"Length of sentence: {length}"
      break

#———————————————————————————————————————————————————————————————————————————————————————————————————

displayLetterCounts(201)
for n in [1_000, 10_000, 100_000, 1_000_000, 10_000_000]:
  echo ""
  displayWord(n)
