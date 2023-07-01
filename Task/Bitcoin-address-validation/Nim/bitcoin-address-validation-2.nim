import nimcrypto
import strformat

const

  DecodedLength = 25    # Decoded address length.
  CheckSumLength = 4    # Checksum length in address.

# Representation of a decoded address.
type Bytes25 = array[DecodedLength, byte]


#---------------------------------------------------------------------------------------------------

proc base58Decode(input: string): Bytes25 =
  ## Decode a base58 encoded bitcoin address.

  const Base = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

  for ch in input:

    var n = Base.find(ch)
    if n < 0:
      raise newException(ValueError, "invalid character: " & ch)

    for i in countdown(result.high, 0):
      n += 58 * result[i].int
      result[i] = byte(n and 255)
      n = n div 256

    if n != 0:
      raise newException(ValueError, "decoded address is too long")

#---------------------------------------------------------------------------------------------------

proc verifyChecksum(data: Bytes25) =
  ## Verify that data has the expected checksum.

  var digest = sha256.digest(data.toOpenArray(0, data.high - CheckSumLength))
  digest = sha256.digest(digest.data)
  if digest.data[0..<CheckSumLength] != data[^CheckSumLength..^1]:
    raise newException(ValueError, "wrong checksum")

#---------------------------------------------------------------------------------------------------

proc checkValidity(address: string) =
  ## Check the validity of a bitcoin address.

  try:
    if address[0] notin {'1', '3'}:
      raise newException(ValueError, "starting character is not 1 or 3")
    if address.len < 26:
      raise newException(ValueError, "address too short")

    address.base58Decode().verifyChecksum()
    echo fmt"Address “{address}” is valid."

  except ValueError:
    echo fmt"Address “{address}” is invalid ({getCurrentExceptionMsg()})."


#———————————————————————————————————————————————————————————————————————————————————————————————————

const testVectors : seq[string] = @[
      "3yQ",                                    # Invalid.
      "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9",     # Valid.
      "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",     # Valid.
      "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nJ9",     # Invalid.
      "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62I",     # Invalid.
      "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62ix",    # Invalid.
      "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62ixx",   # Invalid.
      "17NdbrSGoUotzeGCcMMCqnFkEvLymoou9j",     # Valid.
      "1badbadbadbadbadbadbadbadbadbadbad",     # Invalid.
      "16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM",      # Valid.
      "1111111111111111111114oLvT2",            # Valid.
      "BZbvjr"]                                 # Invalid.

for vector in testVectors:
  vector.checkValidity()
