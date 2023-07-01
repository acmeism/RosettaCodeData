import random
import strformat
import strutils

type

  # Enumeration type for bases.
  Base {.pure.} = enum A, C, G, T, Other = "other"

  # Sequence of bases.
  DnaSequence = string

  # Kind of mutation.
  Mutation = enum mutSwap, mutDelete, mutInsert

const MaxBaseVal = ord(Base.high) - 1   # Maximum base value.

#---------------------------------------------------------------------------------------------------

template toChar(base: Base): char = ($base)[0]

#---------------------------------------------------------------------------------------------------

proc newDnaSeq(length: Natural): DnaSequence =
  ## Create a DNA sequence of given length.

  result = newStringOfCap(length)
  for _ in 1..length:
    result.add($Base(rand(MaxBaseVal)))

#---------------------------------------------------------------------------------------------------

proc mutate(dnaSeq: var DnaSequence) =
  ## Mutate a sequence (it is changed in place).

  # Choose randomly the position of mutation.
  let idx = rand(dnaSeq.high)

  # Choose randomly the kind of mutation.
  let mut = Mutation(rand(ord(Mutation.high)))

  # Apply the mutation.
  case mut

  of mutSwap:
    let newBase = Base(rand(MaxBaseVal))
    echo fmt"Changing base at position {idx + 1} from {dnaSeq[idx]} to {newBase}"
    dnaSeq[idx] = newBase.toChar

  of mutDelete:
    echo fmt"Deleting base {dnaSeq[idx]} at position {idx + 1}"
    dnaSeq.delete(idx, idx)

  of mutInsert:
    let newBase = Base(rand(MaxBaseVal))
    echo fmt"Inserting base {newBase} at position {idx + 1}"
    dnaSeq.insert($newBase, idx)

#---------------------------------------------------------------------------------------------------

proc display(dnaSeq: DnaSequence) =
  ## Display a DNA sequence using EMBL format.

  var counts: array[Base, Natural]    # Count of bases.
  for c in dnaSeq:
    inc counts[parseEnum[Base]($c, Other)]  # Use Other as default value.

  # Display the SQ line.
  var sqline = fmt"SQ   {dnaSeq.len} BP; "
  for (base, count) in counts.pairs:
    sqline &= fmt"{count} {base}; "
  echo sqline

  # Display the sequence.
  var idx = 0
  var row = newStringOfCap(80)
  var remaining = dnaSeq.len

  while remaining > 0:
    row.setLen(0)
    row.add("     ")

    # Add groups of 10 bases.
    for group in 1..6:
      let nextIdx = idx + min(10, remaining)
      for i in idx..<nextIdx:
        row.add($dnaSeq[i])
      row.add(' ')
      dec remaining, nextIdx - idx
      idx = nextIdx
      if remaining == 0:
        break

    # Append the number of the last base in the row.
    row.add(spaces(72 - row.len))
    row.add(fmt"{idx:>8}")
    echo row

  # Add termination.
  echo "//"

#———————————————————————————————————————————————————————————————————————————————————————————————————

randomize()
var dnaSeq = newDnaSeq(200)
echo "Initial sequence"
echo "———————————————\n"
dnaSeq.display()

echo "\nMutations"
echo "—————————\n"
for _ in 1..10:
  dnaSeq.mutate()

echo "\nMutated sequence"
echo "————————————————\n"
dnaSeq.display()
