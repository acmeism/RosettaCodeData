import math, sequtils, strformat, strutils


proc genSequence(ones: seq[string]; numZeroes: Natural): seq[string] =
  if ones.len == 0: return @[repeat('0', numZeroes)]
  for x in 1..(numZeroes - ones.len + 1):
    let skipOne = ones[1..^1]
    for tail in genSequence(skipOne, numZeroes - x):
      result.add repeat('0', x) & ones[0] & tail


proc printBlock(data: string; length: Positive) =

  let a = mapIt(data, ord(it) - ord('0'))
  let sumBytes = sum(a)

  echo &"\nblocks {($a)[1..^1]} cells {length}"
  if length - sumBytes <= 0:
    echo "No solution"
    return

  var prep: seq[string]
  for b in a: prep.add repeat('1', b)

  for r in genSequence(prep, length - sumBytes + 1):
    echo r[1..^1]


when isMainModule:
  printBlock("21", 5)
  printBlock("", 5)
  printBlock("8", 10)
  printBlock("2323", 15)
  printBlock("23", 5)
