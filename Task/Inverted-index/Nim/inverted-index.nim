import os, strformat, strutils, tables

type

  WordRef = tuple[docnum, linenum: int]

  InvertedIndex = object
    docs: seq[string]
    index: Table[string, seq[WordRef]]

  SearchResult = object
    total: int
    refs: seq[tuple[docname: string; linenums: seq[int]]]

  IndexingError = object of CatchableError

const

  # Characters composing a word (letters + "'").
  WordChars = Letters + {'\''}

  # Words to ignore.
  StopWords = ["about", "above", "after", "again", "against", "all", "am", "an", "and", "any",
               "are", "aren't", "as", "at", "be", "because", "been", "before", "being", "below",
               "between", "both", "but", "by", "can't", "cannot", "could", "couldn't",  "did",
               "didn't", "do", "does", "doesn't", "doing", "don't", "down", "during", "each",
               "few", "for", "from", "further", "had", "hadn't", "has", "hasn't", "have",
               "haven't", "having", "he", "he'd", "he'll", "he's", "her", "here", "here's",
               "hers", "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll",
               "i'm", "i've", "if", "in", "into", "is", "isn't", "it", "it's", "its", "itself",
               "let's", "me", "more", "most", "mustn't", "my", "myself", "no", "nor", "not",
               "of", "off", "on", "once", "only", "or", "other", "ought", "our", "ours",
               "ourselves", "out", "over", "own", "same", "shan't", "she", "she'd", "she'll",
               "she's", "should", "shouldn't", "so", "some", "such", "than", "that", "that's",
               "the", "their", "theirs", "them", "themselves", "then", "there", "there's",
               "these", "they", "they'd", "they'll", "they're", "they've", "this", "those",
               "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we",
               "we'd", "we'll", "we're", "we've", "were", "weren't", "what", "what's", "when",
               "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why",
               "why's", "with", "won't", "would", "wouldn't", "you", "you'd", "you'll", "you're",
               "you've", "your", "yours", "yourself", "yourselves"]


template plural(n: int): string = (if n > 1: "s" else: "")


proc add(invIndex: var InvertedIndex; docPath: string) =
  ## Add a document to the index.

  let docName = docPath.extractFilename()
  if docName in invIndex.docs:
    raise newException(IndexingError, &"{docName}: a document with this name is alreadry indexed.")
  invIndex.docs.add docName
  let docIndex = invIndex.docs.high

  var linenum = 0
  var count = 0

  try:
    for line in docPath.lines:
      inc linenum
      var word = ""
      for ch in line:
        if ch in WordChars:
          word.add ch.toLowerAscii()
        else:
          if word.len > 1 and word notin StopWords:
            invIndex.index.mgetOrPut(word, newSeq[WordRef]()).add (docIndex, linenum)
            inc count
          word = ""

  except IOError:
    raise newException(IndexingError, &"{docName}: error while reading file.")

  if count > 0:
    echo &"{docName}: {count} word{plural(count)} indexed."
  else:
    raise newException(IndexingError, &"{docName}: nothing to index.")


func status(invIndex: InvertedIndex): string =
  ## Display information about the inverted index status.
  let words = invIndex.index.len
  let docs = invIndex.docs.len
  &"Index contains {words} word{plural(words)} from {docs} document{plural(docs)}."


proc search(invIndex: InvertedIndex; word: string): SearchResult =
  ## Search a word in the inverted index.
  ## The references are grouped by document.

  let refs = invIndex.index.getOrDefault(word)
  if refs.len == 0: return

  result.total = refs.len
  var prevdoc = ""
  var prevline = 0
  for (docnum, linenum) in refs:
    let docname = invIndex.docs[docnum]
    if docname == prevDoc:
      if linenum != prevline:
        result.refs[^1].linenums.add(linenum)
        prevline = linenum
    else:
      result.refs.add((docname, @[linenum]))
      prevdoc = docname
      prevline = linenum


#———————————————————————————————————————————————————————————————————————————————————————————————————

var invertedIndex: InvertedIndex

if paramCount() != 1 or not paramStr(1).dirExists():
  quit &"Usage: {getAppFileName().lastPathPart} directory"

# Index the documents.
for doc in walkFiles(paramStr(1) / "*.txt"):
  try:
    invertedIndex.add(doc)
  except IndexingError:
    echo getCurrentExceptionMsg()

echo invertedIndex.status()
echo ""

# Enter search interface.
var word: string
while true:
  try:
    stdout.write "Word to search? "
    word = stdin.readLine().toLowerAscii().strip()
    if word == "q":
      echo "Quitting"
      break
    if not word.allCharsInSet(WordChars):
      echo "This word contains invalid characters."
      continue
  except EOFError:
    echo ""
    echo "Quitting"
    break

  # Search word.
  let result = invertedIndex.search(word)
  if result.refs.len == 0:
    echo "No reference found for this word."
    continue

  # Display the references.
  echo &"Found {result.total} reference{plural(result.total)} to “{word}”:"
  for (docname, linenums) in result.refs:
    stdout.write &"... in “{docName}”, line{plural(linenums.len)}"
    for num in linenums: stdout.write ' ', num
    echo ""
