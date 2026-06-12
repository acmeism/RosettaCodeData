import random, sequtils, strutils

proc dnaSequence(n: Positive): string =
  ## Create a random DNA sequence of length "n".
  newSeqWith(n, sample("ACGT")).join()

proc positions(dnaSeq, subSeq: string): seq[int] =
  ## Return the list of starting positions of a subsequence
  ## "subSeq" in a sequence "dnaSeq". Positions start at 1.
  var start = 0
  while true:
    let pos = dnaSeq.find(subSeq, start)
    if pos < 0: break
    result.add pos + 1
    start = pos + 1


when isMainModule:

  const
    N = 200
    Step = 20

  randomize()

  let dnaSeq = dnaSequence(N)
  echo "DNA sequence:"
  for i in countup(0, N - 1, Step):
    echo ($(i+1)).align(3), ' ', dnaSeq[i..i+(Step-1)]

  let subSeq = dnaSequence(3)
  echo "\nDNA subsequence: ", subSeq

  echo()
  let pos = dnaSeq.positions(subSeq)
  if pos.len == 0:
    echo "Subsequence not found."
  else:
    let tail = if pos.len == 1: ": " else: "s: "
    echo "Subsequence found at position", tail, pos.join(", ")
