import algorithm
from sequtils import repeat
import strutils except repeat

const
  Stx = '\2'
  Etx = '\3'

#---------------------------------------------------------------------------------------------------

func bwTransform*(s: string): string =
  ## Apply Burrows–Wheeler transform to input string.

  doAssert(Stx notin s and Etx notin s, "Input string cannot contain STX and ETX characters")

  let s = Stx & s & Etx  # Add start and end of text marker.

  # Build the table of rotated strings and sort it.
  var table = newSeqOfCap[string](s.len)
  for i in 0..s.high:
    table.add(s[i + 1..^1] & s[0..i])
  table.sort()

  # Extract last column of the table.
  for item in table:
    result.add(item[^1])

#---------------------------------------------------------------------------------------------------

func invBwTransform*(r: string): string =
  ## Apply inverse Burrows–Wheeler transform.

  # Build table.
  var table = repeat("", r.len)
  for _ in 1..r.len:
    for i in 0..<r.len:
      table[i] = r[i] & table[i]
    table.sort()

  # Find the correct row (ending in ETX).
  var idx = 0
  while not table[idx].endsWith(Etx):
    inc idx
  result = table[idx][1..^2]


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  proc displaybleString(s: string): string =
    ## Build a displayable string from a string containing STX and ETX characters.

    s.multiReplace(("\2", "¹"), ("\3", "²"))

  for text in ["banana",
               "appellee",
               "dogwood",
               "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
               "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES"]:
    let transformed = text.bwTransform()
    let invTransformed = transformed.invBwTransform()

    echo ""
    echo "Original text:                ", text
    echo "After transformation:         ", transformed.displaybleString()
    echo "After inverse transformation: ", invTransformed
