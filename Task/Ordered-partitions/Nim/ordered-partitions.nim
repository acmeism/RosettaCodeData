import algorithm, math, sequtils, strutils

type Partition = seq[seq[int]]


func isIncreasing(s: seq[int]): bool =
  ## Return true if the sequence is sorted in increasing order.
  var prev = 0
  for val in s:
    if prev >= val: return false
    prev = val
  result = true


iterator partitions(lengths: varargs[int]): Partition =
  ## Yield the partitions for lengths "lengths".

  # Build the list of slices to use for partitionning.
  var slices: seq[Slice[int]]
  var delta = -1
  var idx = 0
  for length in lengths:
    assert length >= 0, "lengths must not be negative."
    inc delta, length
    slices.add idx..delta
    inc idx, length

  # Build the partitions.
  let n = sum(lengths)
  var perm = toSeq(1..n)
  while true:

    block buildPartition:
      var part: Partition
      for slice in slices:
        let s = perm[slice]
        if not s.isIncreasing():
          break buildPartition
        part.add s
      yield part

    if not perm.nextPermutation():
      break


func toString(part: Partition): string =
  ## Return the string representation of a partition.
  result = "("
  for s in part:
    result.addSep(", ", 1)
    result.add '{' & s.join(", ") & '}'
  result.add ')'


when isMainModule:

  import os

  proc displayPermutations(lengths: varargs[int]) =
    ## Display the permutations.
    echo "Ordered permutations for (", lengths.join(", "), "):"
    for part in partitions(lengths):
      echo part.toString

  if paramCount() > 0:
    var args: seq[int]
    for param in commandLineParams():
      try:
        let val = param.parseInt()
        if val < 0: raise newException(ValueError, "")
        args.add val
      except ValueError:
        quit "Wrong parameter: " & param
    displayPermutations(args)

  else:
    displayPermutations(2, 0, 2)
