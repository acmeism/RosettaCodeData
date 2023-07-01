import tables, strutils, sequtils, httpclient

proc take[T](s: openArray[T], n: int): seq[T] = s[0 ..< min(n, s.len)]

var client = newHttpClient()
var text = client.getContent("https://www.gutenberg.org/files/135/135-0.txt")

var wordFrequencies = text.toLowerAscii.splitWhitespace.toCountTable
wordFrequencies.sort
for (word, count) in toSeq(wordFrequencies.pairs).take(10):
  echo alignLeft($count, 8), word
