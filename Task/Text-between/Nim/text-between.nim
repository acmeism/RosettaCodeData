import strutils

func textBetween(text, startStr, endStr: string): string =
  ## Return the text between start and end separators.

  var startIdx = 0
  if startStr != "start":
    startIdx = text.find(startStr)
    if startIdx == -1: return
    inc startIdx, startStr.len

  var endIdx = text.high
  if endStr != "end":
    endIdx = text.find(endStr, startIdx)
    if endIdx == -1: endIdx = text.high
    else: dec endIdx

  result = text.substr(startIdx, endIdx)


proc quote(s: string): string =
  ## Return a quoted string, i.e with escaped chars but
  ## keeping unchanged characters between \128 and \255.
  result.addQuoted(s)


const Data = [
  ("Hello Rosetta Code world", "Hello ", " world"),
  ("Hello Rosetta Code world", "start", " world"),
  ("Hello Rosetta Code world", "Hello ", "end"),
  ("</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>"),
  ("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>"),
  ("<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>"),
  ("The quick brown fox jumps over the lazy other fox", "quick ", " fox"),
  ("One fish two fish red fish blue fish", "fish ", " red"),
  ("FooBarBazFooBuxQuux", "Foo", "Foo")]

for (text, startStr, endStr) in Data:
  echo "Text:   ", text.quote
  echo "Start:  ", startStr.quote
  echo "End:    ", endStr.quote
  echo "Output: ", text.textBetween(startStr, endStr).quote
  echo()
