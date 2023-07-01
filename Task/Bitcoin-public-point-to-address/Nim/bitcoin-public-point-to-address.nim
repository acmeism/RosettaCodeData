import parseutils
import nimcrypto
import bignum

func base58Encode(data: seq[byte]): string =
  ## Encode data to base58 with at most one starting '1'.

  var data = data
  const Base = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
  result.setlen(34)

  # Convert to base 58.
  for j in countdown(result.high, 0):
    var c = 0
    for i, b in data:
      c = c * 256 + b.int
      data[i] = (c div 58).byte
      c = c mod 58
    result[j] = Base[c]

  # Keep one starting '1' at most.
  if result[0] == '1':
    for idx in 1..result.high:
      if result[idx] != '1':
        result = result[(idx - 1)..^1]
        break

func hexToByteSeq(s: string): seq[byte] =
  ## Convert a hexadecimal string to a sequence of bytes.

  var pos = 0
  while pos < s.len:
    var tmp = 0
    let parsed = parseHex(s, tmp, pos, 2)
    if parsed > 0:
      inc pos, parsed
      result.add byte tmp
    else:
      raise newException(ValueError, "Invalid hex string")

func validCoordinates(x, y: string): bool =
  ## Return true if the coordinates are those of a point in the secp256k1 elliptic curve.

  let p = newInt("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F", 16)
  let x = newInt(x, 16)
  let y = newInt(y, 16)
  result = y^2 mod p == (x^3 + 7) mod p

func addrEncode(x, y: string): string =
  ## Encode x and y coordinates to an address.

  if not validCoordinates(x, y):
    raise newException(ValueError, "Invalid coordinates")

  let pubPoint = 4u8 & x.hexToByteSeq & y.hexToByteSeq
  if pubPoint.len != 65:
    raise newException(ValueError, "Invalid pubpoint string")

  var rmd = @(ripemd160.digest(sha256.digest(pubPoint).data).data)
  rmd.insert 0u8
  rmd.add sha256.digest(sha256.digest(rmd).data).data[0..3]
  result = base58Encode(rmd)

when isMainModule:
  let address = addrEncode("50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352",
                           "2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6")
  echo "Coordinates are valid."
  echo "Address is: ", address
