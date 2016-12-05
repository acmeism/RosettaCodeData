from strutils import contains, format, toUpper
from sequtils import delete

proc canMakeWord(s: string): bool =
  var
    abcs = @["BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS",
             "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"]
    matched = newSeq[string]()

  if s.len > abcs.len:
    return false

  for i in 0 .. s.len - 1:
    var
      letter = s[i].toUpper
      n = 0
    for abc in abcs:
      if contains(abc, letter):
        delete(abcs, n, n)
        matched = matched & abc
        break
      else:
        inc(n)

  if matched.len == s.len:
    return true
  else:
    return false

var words = @["A", "bArK", "BOOK", "treat", "common", "sQuAd", "CONFUSE"]
for word in words:
  echo format("Can the blocks make the word \"$1\"? $2", word,
    (if canMakeWord(word): "yes" else: "no"))
