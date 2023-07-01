import strutils, sugar, tables

const Grid = """N D E
                O K G
                E L W"""

let letters = Grid.toLowerAscii.splitWhitespace.join()

let words = collect(newSeq):
              for word in "unixdict.txt".lines:
                if word.len in 3..9:
                  word

let midLetter = letters[4]

let gridCount = letters.toCountTable
for word in words:
  block checkWord:
    if midLetter in word:
      for ch, count in word.toCountTable.pairs:
        if count > gridCount[ch]:
          break checkWord
      echo word
