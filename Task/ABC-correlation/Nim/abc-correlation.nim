import std/tables

proc abcCorr(s: string; min = 0): bool =
  ## Return true if "s" contains the same number of letters
  ## 'a', 'b', and 'c' and at least "min" occurrences of them.
  let counts = s.toCountTable()
  let aCount = counts['a']
  result = acount >= min and counts['b'] == aCount and counts['c'] == aCount

for word in lines("words_alpha.txt"):
  if word.abcCorr(min = 2):
    echo word
