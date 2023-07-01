import strutils

const Phrase = "rosetta code phrase reversal"

proc reversed(s: string): string =
  for i in countdown(s.high, 0):
    result.add s[i]

proc reversedWords(s: string): string =
  let words = s.split()
  result = reversed(words[0])
  for i in 1..words.high:
    result.add ' ' & reversed(words[i])

proc reversedWordOrder(s: string): string =
  let words = s.split()
  result = words[^1]
  for i in countdown(words.high - 1, 0):
    result.add ' ' & words[i]

echo "Phrase:              ", Phrase
echo "Reversed phrase:     ", reversed(Phrase)
echo "Reversed words:      ", reversedWords(Phrase)
echo "Reversed word order: ", reversedWordOrder(Phrase)
