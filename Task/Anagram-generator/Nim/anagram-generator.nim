import std/[algorithm, sequtils, strutils, tables]

proc readWords(filename: string): seq[string] {.compileTime.} =
  result = filename.staticRead().splitLines().map(toLowerAscii)

const UnixWords = readWords("unixdict.txt")

func findPhrases(anaString: string; choices: seq[string];
                 sizeLong = 4; nShortPermitted = 1): seq[string] =
  var anaDict: CountTable[char]
  for c in anaString.toLowerAscii:
    if c in 'a'..'z':
      anadict.inc(c)
  var phrases: seq[string]

  func addWord(remaining: CountTable[char]; phrase: string; numShort: int): string =
    for word in UnixWords:
      block Search:
        if numShort < 1 and word.len < sizeLong:
          break Search
        if anyIt(word, remaining.getOrDefault(it) < word.count(it)):
          break Search
        var cdict = remaining
        for c in word: cdict.inc(c, -1)
        if allIt(cdict.values.toSeq, it == 0):
          return strip(phrase & ' ' & word)
        let newPhrase = addWord(cdict, phrase & ' ' & word, numshort - ord(word.len < sizeLong))
        if newPhrase.len > 0:
          phrases.add newPhrase

  discard addWord(anaDict, "", nShortPermitted)
  result = move(phrases)

for s in ["Rosetta code", "Joe Biden", "wherrera"]:
  echo "From '$#':" % s
  for phrase in findPhrases(s, UnixWords, 4, 0).sorted.deduplicate(true):
    echo phrase
  echo()
