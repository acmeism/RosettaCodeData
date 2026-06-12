import sequtils, strutils
import bignum

const CodeString = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"


proc toBase58*(hashValue: string): string =
  ## Convert a hash value provided as a string to its base 58 representation.

  # Build a big integer from the string.
  var hexval = ""
  var val: Int
  if hashValue.startsWith("0x"):
    hexval = hashValue[2..^1]
    val = newInt(hexval, 16)
  else:
    val = newInt(hashValue, 10)

  # Convert to base 58.
  while val > 0:
    result.add CodeString[(val mod 58).toInt]
    val = val div 58

  # Add codes for leading zeroes.
  for c in hexval:
    if c == '0': result.add '1'
    else: break

  # Reverse string.
  let h = result.high
  for i in 0..(h div 2):
    swap result[i], result[h - i]


proc toBase58*(hashValue: openArray[byte]): string =
  ## Convert an array or sequence of bytes to base 58.
  toBase58("0x" & hashValue.join().toHex)


when isMainModule:

  const Hashes = ["0x00010966776006953D5567439E5E39F86A0D273BEED61967F6",
                  "0x61",
                  "0x626262",
                  "0x636363",
                  "0x73696d706c792061206c6f6e6720737472696e67",
                  "0x516b6fcd0f",
                  "0xbf4f89001e670274dd",
                  "0x572e4794",
                  "0xecac89cad93923c02321",
                  "0x10c8511e"]

  const MaxLength = max(Hashes.mapIt(it.len))

  for h in Hashes:
    echo h.alignLeft(MaxLength), " → ", h.toBase58
