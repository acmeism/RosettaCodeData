import algorithm, sugar, tables

var charCount: CountTable[char]

for str in ["133252abcdeeffd", "a6789798st", "yxcdfgxcyz"]:
  charCount.merge str.toCountTable

let uniqueChars = collect(newSeq):
                    for ch, count in charCount.pairs:
                      if count == 1: ch

echo sorted(uniqueChars)
