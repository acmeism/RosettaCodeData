import strformat
import strutils

const Source = "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG" &
               "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG" &
               "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT" &
               "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT" &
               "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG" &
               "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA" &
               "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT" &
               "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG" &
               "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC" &
               "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT"

# Enumeration type for bases.
type Base* {.pure.} = enum A, C, G, T, Other = "other"

proc display*(dnaSeq: string) =
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
      row.add(dnaSeq[idx..<nextIdx] & ' ')
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


when isMainModule:
  Source.display()
