import strutils

const Vowels = ['a', 'e', 'i', 'o', 'u']

var count = 0
for word in "unixdict.txt".lines:
  if word.len > 10:
    block checkWord:
      for vowel in Vowels:
        if word.count(vowel) != 1:
          break checkWord
      inc count
      stdout.write word.align(15), if count mod 5 == 0: '\n' else: ' '
