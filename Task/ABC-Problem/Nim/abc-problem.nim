from strutils import toUpperAscii, contains, format
from sequtils import delete

proc makeWord(s: string): bool =
  var
    abcs = @["BO", "XK", "DQ", "CP", "NA", "GT", "RE", "TG", "QD", "FS",
             "JW", "HU", "VI", "AN", "OB", "ER", "FS", "LY", "PC", "ZM"]

  if s.len > abcs.len:
    return false

  for ch in s.toUpperAscii.items:
    block outer:
      for i, abc in abcs.pairs:
        if abc.contains(ch):
          abcs.delete(i)
          break outer
      return false
  return true

let words =  @["A", "bArK", "BOOK", "treat", "common", "sQuAd", "CONFUSE"]
for word in words:
  echo format("""Can the blocks make the word "$1"? $2 """, word,
              if makeWord(word): "yes" else: "no")
