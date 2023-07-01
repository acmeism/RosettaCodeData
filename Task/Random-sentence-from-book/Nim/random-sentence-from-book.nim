import random, sequtils, strutils, tables
from unicode import utf8

const StopChars = [".", "?", "!"]

proc weightedChoice(choices: CountTable[string]; totalCount: int): string =
  ## Return a string from "choices" key using counts as weights.
  var n = rand(1..totalCount)
  for word, count in choices.pairs:
    dec n, count
    if n <= 0: return word
  assert false, "internal error"

proc finalFilter(words: seq[string]): seq[string] =
  ## Eliminate words of length one (except those of a given list)
  ## and words containing only uppercase letters (words from titles).
  for word in words:
    if word in [".", "?", "!", "I", "A", "a"]:
      result.add word
    elif word.len > 1 and any(word, isLowerAscii):
      result.add word


randomize()

var text = readFile("The War of the Worlds.txt")

# Extract the actual text from the book.
const
  StartText = "BOOK ONE\r\nTHE COMING OF THE MARTIANS"
  EndText = "End of the Project Gutenberg EBook"
let startIndex = text.find(StartText)
let endIndex = text.find(EndText)
text = text[startIndex..<endIndex]

# Clean the text by removing some characters and replacing others.
# As there are some non ASCII characters, we have to apply special rules.
var processedText: string
for uchar in text.utf8():
  if uchar.len == 1:
    # ASCII character.
    let ch = uchar[0]
    case ch
    of '0'..'9', 'a'..'z', 'A'..'Z', ' ': processedText.add ch  # Keep as is.
    of '\n': processedText.add ' '                              # Replace with a space.
    of '.', '?', '!': processedText.add ' ' & ch                # Make sure these characters are isolated.
    else: discard                                               # Remove others.
  else:
    # Some UTF-8 representation of a non ASCII character.
    case uchar
    of "—": processedText.add ' '                               # Replace EM DASH with space.
    of "ç", "æ", "’": processedText.add uchar                   # Keep these characters as they are parts of words.
    of "“", "”", "‘": discard                                   # Removed these ones.
    else: echo "encountered: ", uchar                           # Should not go here.

# Extract words and filter them.
let words = processedText.splitWhitespace().finalFilter()

# Build count tables.
var followCount, followCount2: Table[string, CountTable[string]]
for i in 1..words.high:
  followCount.mgetOrPut(words[i - 1], initCountTable[string]()).inc(words[i])
for i in 2..words.high:
  followCount2.mgetOrPut(words[i - 2] & ' ' & words[i - 1], initCountTable[string]()).inc words[i]

# Build sum tables.
var followSum, followSum2: CountTable[string]
for key in followCount.keys:
  for count in followCount[key].values:
    followSum.inc key, count
for key in followCount2.keys:
  for count in followCount2[key].values:
    followSum2.inc key, count

# Build table of starting words and compute the sum.
var
  startingWords: CountTable[string]
  startingSum: int
for stopChar in StopChars:
  for word, count in followCount[stopChar].pairs:
    startingWords.inc word, count
    inc startingSum, count

# Build a sentence.
let firstWord = weightedChoice(startingWords, startingSum)
var sentence = @[firstWord]
var lastWord = weightedChoice(followCount[firstWord], followSum[firstWord])
while lastWord notin StopChars:
  sentence.add lastWord
  let key = sentence[^2] & ' ' & lastWord
  lastWord = if key in followCount2:
               weightedChoice(followCount2[key], followSum2[key])
             else:
               weightedChoice(followCount[lastWord], followSum[lastWord])
echo sentence.join(" ") & lastWord
