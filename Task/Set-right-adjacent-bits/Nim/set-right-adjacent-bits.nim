import std/[bitops, strformat]

type
  # Bit string described by a length and a sequence of bytes.
  BitString = object
    len: Natural
    data: seq[byte]
  # Position composed of a byte number and
  # a bit number in the byte (starting from the left).
  Position = tuple[bytenum, bitnum: int]

func toPosition(n: Natural): Position =
  ## Convert an index to a Position.
  (n div 8, 7 - n mod 8)

proc newBitString*(len: Natural): BitString =
  ## Create a bit string of length "len".
  result.len = len
  result.data = newSeq[byte]((len + 7) div 8)

func checkIndex(bits: BitString; n: Natural) =
  ## Check that the index "n" is not out of bounds.
  if n >= bits.len:
    raise newException(RangeDefect, &"index out of range: {n}.")

proc `[]`*(bits: BitString; n: Natural): bool =
  ## Return the bit at index "n" (as a boolean).
  bits.checkIndex(n)
  let pos = n.toPosition
  result = bits.data[pos.bytenum].testBit(pos.bitnum)

func setBit*(bits: var BitString; n: Natural) =
  ## Set the bit at index "n".
  bits.checkIndex(n)
  let pos = n.toPosition
  bits.data[pos.bytenum].setBit(pos.bitnum)

func clearBit*(bits: var BitString; n: Natural) =
  ## Clear the bit at index "n".
  ## Not used but provided for consistency.
  bits.checkIndex(n)
  let pos = n.toPosition
  bits.data[pos.bytenum].clearBit(pos.bitnum)

iterator items*(bits: BitString): bool =
  ## Yield the successive bits of the bit string.
  for n in 0..<bits.len:
    yield bits[n]

func toBitString*(s: string): BitString =
  ## Convert a string of '0' and '1' to a bit string.
  result = newBitString(s.len)
  for n, val in s:
    if val == '1':
      result.setBit(n)
    elif val != '0':
      raise newException(ValueError, &"invalid bit value: {val}")

func `$`*(bits: BitString): string =
  ## Return the string representation of a bit string.
  const BinDigits = [false: '0', true: '1']
  for bit in bits.items:
    result.add BinDigits[bit]

func setAdjacentBitString(bits: BitString; n: Natural): BitString =
  ## Set the "n" bits adjacent to a set bit.
  result = bits
  for i in 0..<bits.len:
    if bits[i]:
      for j in (i + 1)..(i + n):
        if j < bits.len:
          result.setBit(j)

let n = 2
echo &"n = {n}; Width e = 4\n"
for input in ["1000", "0100", "0010", "0000"]:
  echo &"Input:  {input}"
  echo &"Result: {input.toBitString.setAdjacentBitString(n)}"
  echo()

echo()
const BS66 = "010000000000100000000010000000010000000100000010000010000100010010".toBitString
for n in 0..3:
  echo &"n = {n}; Width e = {BS66.len}\n"
  echo "Input:"
  echo BS66
  echo "Result:"
  echo BS66.setAdjacentBitString(n)
  echo()
