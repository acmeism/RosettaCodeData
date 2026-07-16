import std/[random, strutils, streams, sequtils]

var validWords: seq[string]
type
  PredicateError = object of CatchableError

try:
  var
    stream = newFileStream("unixdict.txt", fmRead)
    line: string

  if stream.isNil:
    echo "Illegal attempt to read from nil."
    quit(1)

  while stream.readLine(line):
    if line.strip.allCharsInSet(Letters):
      validWords &= line.strip

  if validWords.len == 0:
    echo "Couldn't find any words in dictionary file."
    quit(1)
except:
  echo "Unable to read 'unixdict.txt' source file."
  quit(1)

proc generate(wordCount: int, wordPred: proc(word: string): bool,
  digitCount: int or HSlice[int, int], separator: string): string =
  randomize()

  if separator.len < 1:
    raise newException(ValueError, "Password separators need at least one character.")
  elif wordCount < 1:
    raise newException(ValueError, "Password needs at least one word.")
  else:
    when digitCount is int:
      if digitCount < 1:
        raise newException(ValueError, "Password separators need at least one character.")
      let digitRange = digitCount..digitCount

    elif digitCount is HSlice[int, int]:
      if digitCount.a < 1 or digitCount.b < 1:
        raise newException(ValueError, "Password words need at least one character.")
      if digitCount.a > digitCount.b:
        raise newException(ValueError, "Subranges should be in ascending order.")
      let digitRange = digitCount

    var wordChoices = validWords.filter(wordPred)
    if wordChoices.len < wordCount:
      raise newException(PredicateError, "Not enough words in dictionary satisfy predicate.")

    for word in 1..wordCount:
      let idx = rand(max = wordChoices.len - 1)
      result &= wordChoices[idx].capitalizeAscii
      wordChoices.delete(idx)

      for i in 1..rand(digitRange):
        result &= $(rand(max = 9))

      if word != wordCount:
        result &= separator

when isMainModule:
  import sugar

  let
    example = generate(
      wordCount = 5,
      wordPred = (x => x in ["hello", "butterfly", "elephant", "rainbow", "sunshine"]),
      digitCount = 2,
      separator = "-"
    )
    xPass = generate(
      wordCount = 3,
      wordPred = (x => 'x' in x),
      digitCount = 2..5,
      separator = "+"
    )
    knowledgePass = generate(
      wordCount = 4,
      wordPred = (x => x.endsWith("ology")),
      digitCount = 1,
      separator = "->"
    )
  dump example
  dump xPass
  dump knowledgePass
