import strutils, sugar

const Vowels = {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'}

proc removeVowels(str: var string; vowels: set[char]) =
  ## Remove vowels from string "str".
  var start = 0
  while true:
    let pos = str.find(vowels, start)
    if pos < 0: break
    str.delete(pos, pos)
    start = pos

const TestString = "The quick brown fox jumps over the lazy dog"
echo TestString
echo TestString.dup(removeVowels(Vowels))
