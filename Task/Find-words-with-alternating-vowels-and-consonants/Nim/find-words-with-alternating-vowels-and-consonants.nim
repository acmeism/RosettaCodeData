import strutils

const Vowels = {'a', 'e', 'i', 'o', 'u'}

var count = 0
for word in "unixdict.txt".lines:
  if word.len > 9:
    block checkWord:
      let first = word[0] in Vowels
      for i in countup(2, word.high, 2):
        if word[i] in Vowels != first: break checkWord
      for i in countup(1, word.high, 2):
        if word[i] in Vowels == first: break checkWord
      inc count
      stdout.write word.align(14), if count mod 7 == 0: '\n' else: ' '
echo()
