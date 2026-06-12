import std/[algorithm, sequtils, strformat, strutils]


proc isIncCountsWord(s, letters: string; min: Positive): bool =
  ## Return true if "s" contains at least "min" occurrences of
  ## the given letters and their sorted counts differs by one.
  var counts: array[3, Natural]
  for ch in s:
    for i, letter in letters:
      if ch == letter: inc counts[i]
  counts.sort()
  let minCount = counts[0]
  result = minCount >= min and counts[1] == minCount + 1 and counts[2] == minCount + 2


proc printIncCountsWords(file, letters: string; min: Positive) =
  ## Print the words present in file "file" with incremental counts
  ## for given letters and at least "min" occurrences.

  proc plural(val: Positive): string =
    if val == 1: "" else: "s"

  assert letters.len == 3, &"Expected 3 letters, got {letters.len}."

  let s = letters.mapIt("'" & it & "'").join(", ")
  echo &"Filtering “{file}” for letters {s} with at least {min} occurrence{plural(min)}:"
  var n = 0
  for word in lines(file):
    if word.isIncCountsWord(letters, min):
      inc n
      echo "  " & word
  if n == 0: echo "  <None>"
  echo()

printIncCountsWords("unixdict.txt", "abc", 1)
printIncCountsWords("unixdict.txt", "the", 1)
printIncCountsWords("unixdict.txt", "cio", 2)

printIncCountsWords("words_alpha.txt", "abc", 2)
printIncCountsWords("words_alpha.txt", "the", 2)
printIncCountsWords("words_alpha.txt", "cio", 3)
