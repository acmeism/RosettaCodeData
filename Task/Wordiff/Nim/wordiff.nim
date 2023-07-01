import httpclient, sequtils, sets, strutils, sugar
from unicode import capitalize

const
  DictFname = "unixdict.txt"
  DictUrl1 = "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"    # ~25K words
  DictUrl2 = "https://raw.githubusercontent.com/dwyl/english-words/master/words.txt"  # ~470K words


type Dictionary = HashSet[string]


proc loadDictionary(fname = DictFname): Dictionary =
  ## Return appropriate words from a dictionary file.
  for word in fname.lines():
    if word.len >= 3 and word.allCharsInSet(Letters): result.incl word.toLowerAscii


proc loadWebDictionary(url: string): Dictionary =
  ## Return appropriate words from a dictionary web page.
  let client = newHttpClient()
  for word in client.getContent(url).splitLines():
    if word.len >= 3 and word.allCharsInSet(Letters): result.incl word.toLowerAscii


proc getPlayers(): seq[string] =
  ## Return inputted ordered list of contestant names.
  try:
    stdout.write "Space separated list of contestants: "
    stdout.flushFile()
    result = stdin.readLine().splitWhitespace().map(capitalize)
    if result.len == 0:
      quit "Empty list of names. Quitting.", QuitFailure
  except EOFError:
    echo()
    quit "Encountered end of file. Quitting.", QuitFailure


proc isWordiffRemoval(word, prev: string; comment = true): bool =
  ## Is "word" derived from "prev" by removing one letter?
  for i in 0..prev.high:
    if word == prev[0..<i] & prev[i+1..^1]: return true
  if comment: echo "Word is not derived from previous by removal of one letter."
  result = false


proc isWordiffInsertion(word, prev: string; comment = true): bool =
  ## Is "word" derived from "prev" by adding one letter?
  for i in 0..word.high:
    if prev == word[0..<i] & word[i+1..^1]: return true
  if comment: echo "Word is not derived from previous by insertion of one letter."
  return false


proc isWordiffChange(word, prev: string; comment = true): bool =
  ## Is "word" derived from "prev" by changing exactly one letter?
  var diffcount = 0
  for i in 0..word.high:
    diffcount += ord(word[i] != prev[i])
  if diffcount != 1:
    if comment:
      echo "More or less than exactly one character changed."
    return false
  result = true


proc isWordiff(word: string; wordiffs: seq[string]; dict: Dictionary; comment = true): bool =
  ## Is "word" a valid wordiff from "wordiffs[^1]"?
  if word notin dict:
    if comment:
      echo "That word is not in my dictionary."
      return false
  if word in wordiffs:
    if comment:
      echo "That word was already used."
      return false
  result = if word.len < wordiffs[^1].len: word.isWordiffRemoval(wordiffs[^1], comment)
           elif word.len > wordiffs[^1].len: word.isWordiffInsertion(wordiffs[^1], comment)
           else: word.isWordiffChange(wordiffs[^1], comment)


proc couldHaveGot(wordiffs: seq[string]; dict: Dictionary): seq[string] =
  for word in dict - wordiffs.toHashSet:
    if word.isWordiff(wordiffs, dict, comment = false):
      result.add word


when isMainModule:
  import random

  randomize()
  let dict = loadDictionary(DictFname)
  let dict34 = collect(newSeq):
                 for word in dict:
                   if word.len in [3, 4]: word
  let start = sample(dict34)
  var wordiffs = @[start]
  let players = getPlayers()
  var iplayer = 0
  var word: string
  while true:
    let name = players[iplayer]
    while true:
      stdout.write "$1, input a wordiff from “$2”: ".format(name, wordiffs[^1])
      stdout.flushFile()
      try:
        word = stdin.readLine().strip()
        if word.len > 0: break
      except EOFError:
        quit "Encountered end of file. Quitting.", QuitFailure
    if word.isWordiff(wordiffs, dict):
      wordiffs.add word
    else:
      echo "You have lost, $#.".format(name)
      let possibleWords = couldHaveGot(wordiffs, dict)
      if possibleWords.len > 0:
        echo "You could have used: ", possibleWords[0..min(possibleWords.high, 20)].join(" ")
      break
    iplayer = (iplayer + 1) mod players.len
