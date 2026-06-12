import sequtils, sets, strutils

type
  Dict = HashSet[string]
  WordSeq = seq[string]

proc initDict(words: openArray[string]): Dict =
  ## Initialize a dictionary from a list of words.
  words.toHashSet

proc initDict(fileName: string; minlength = 0): Dict =
  ## Initialize a dictionary with words from a file.
  ## Only words with minimal length are retained.
  for word in filename.lines:
    if word.len >= minLength:
      result.incl word

func wordBreaks(dict: Dict; word: string): seq[WordSeq] =
  ## Build recursively the list of breaks for a word, using the given dictionary.
  for last in 0..<word.high:
    let part1 = word[0..last]
    if part1 in dict:
      let part2 = word[last+1..^1]
      if part2 in dict: result.add(@[part1, part2])
      result.add dict.wordBreaks(part2).mapIt(part1 & it)

proc breakWord(dict: Dict; word: string) =
  ## Find the ways to break a word and display the result.
  echo word, ": "
  let wordSeqs = dict.wordBreaks(word)
  if wordSeqs.len == 0:
    echo "    <no break possible>"
  else:
    for wordSeq in wordSeqs:
      echo "    ", wordSeq.join(" ")

when isMainModule:

  const EDict = ["a", "bc", "abc", "cd", "b"]
  echo "Using explicit dictionary: ", EDict
  var dict = initDict(EDict)
  for s in ["abcd", "abbc", "abcbcd", "acdbc", "abcdd"]:
    dict.breakWord(s)

  echo("\nUsing “unixdict.txt” dictionary without single letter words.")
  dict = initDict("unixdict.txt", 2)
  dict.breakWord("because")
  dict.breakWord("software")
