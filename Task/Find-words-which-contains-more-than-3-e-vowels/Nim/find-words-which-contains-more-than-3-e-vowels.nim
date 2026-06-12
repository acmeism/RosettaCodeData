import strutils

const NonEVowels = ['a', 'i', 'o', 'u']

var count = 0
for word in "unixdict.txt".lines:
  block checkWord:
    if word.count('e') <= 3: break checkWord
    for vowel in NonEVowels:
      if vowel in word: break checkWord
    inc count
    stdout.write word.align(14), if count mod 4 == 0: '\n' else: ' '
