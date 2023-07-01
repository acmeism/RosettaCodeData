import bitops, strutils, std/monotimes, times

const MaxCount = 2 * 1_000_000_000 + 9 * 9

# Bit string used to represent an array of booleans.
type BitString = object
  len: Natural        # length in bits.
  values: seq[byte]   # Sequence containing the bits.


proc newBitString(n: Natural): BitString =
  ## Return a new bit string of length "n" bits.
  result.len = n
  result.values.setLen((n + 7) shr 3)


template checkIndex(i, length: Natural) {.used.} =
  ## Check if index "i" is less than the array length.
  if i >= length:
    raise newException(IndexDefect, "index $1 not in 0 .. $2".format(i, length))


proc `[]`(bs: BitString; i: Natural): bool =
  ## Return the value of bit at index "i" as a boolean.
  when compileOption("boundchecks"):
    checkIndex(i, bs.len)
  result = bs.values[i shr 3].testbit(i and 0x07)


proc `[]=`(bs: var BitString; i: Natural; value: bool) =
  ## Set the bit at index "i" to the given value.
  when compileOption("boundchecks"):
    checkIndex(i, bs.len)
  if value: bs.values[i shr 3].setBit(i and 0x07)
  else: bs.values[i shr 3].clearBit(i and 0x07)


proc fill(sieve: var BitString) =
  ## Fill a sieve.
  var n = 0
  for a in 0..1:
    for b in 0..9:
      for c in 0..9:
        for d in 0..9:
          for e in 0..9:
            for f in 0..9:
              for g in 0..9:
                for h in 0..9:
                  for i in 0..9:
                    for j in 0..9:
                      sieve[a + b + c + d + e + f + g + h + i + j + n] = true
                      inc n


let t0 = getMonoTime()

var sieve = newBitString(MaxCount + 1)
sieve.fill()
echo "Sieve time: ", getMonoTime() - t0

# Find first 50.
echo "\nFirst 50 self numbers:"
var count = 0
var line = ""
for n in 0..MaxCount:
  if not sieve[n]:
    inc count
    line.addSep(" ")
    line.add $n
    if count == 50: break
echo line

# Find 1st, 10th, 100th, ..., 100_000_000th.
echo "\n      Rank       Value"
var limit = 1
count = 0
for n in 0..MaxCount:
  if not sieve[n]: inc count
  if count == limit:
    echo ($count).align(10), ($n).align(12)
    limit *= 10
echo "Total time: ", getMonoTime() - t0
