import strformat, strutils, tables

const Vowels = {'a', 'e', 'i', 'o', 'u'}

template plural(n: int): string = (if n > 1: "s" else: "")

var results: array[0..9, seq[string]]

for word in "unixdict.txt".lines:
  if word.len <= 10: continue

  block checkWord:
    let letterCounts = word.toCountTable
    var consonantCount = 0
    for key, count in letterCounts.pairs:
      if key notin Vowels:
        if count > 1: break checkWord
        if count == 1: inc consonantCount
    results[consonantCount].add word

for n in countdown(9, 4):
  let count = results[n].len
  echo &"\nFound {count} word{plural(count)} with {n} unique consonants:"
  for i, word in results[n]:
    stdout.write word.align(14), if (i + 1) mod 9 == 0: '\n' else: ' '
  echo()
