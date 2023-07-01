import algorithm

const SHA256Len = 32
const AddrLen = 25
const AddrMsgLen = 21
const AddrChecksumOffset = 21
const AddrChecksumLen = 4

proc SHA256(d: pointer, n: culong, md: pointer = nil): cstring {.cdecl, dynlib: "libssl.so", importc.}

proc decodeBase58(inStr: string, outArray: var openarray[uint8]) =
  let base = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

  outArray.fill(0)

  for aChar in inStr:
    var accum = base.find(aChar)

    if accum < 0:
      raise newException(ValueError, "Invalid character: " & $aChar)

    for outIndex in countDown((AddrLen - 1), 0):
      accum += 58 * outArray[outIndex].int
      outArray[outIndex] = (accum mod 256).uint8
      accum = accum div 256

    if accum != 0:
      raise newException(ValueError, "Address string too long")

proc verifyChecksum(addrData: openarray[uint8]) : bool =
  let doubleHash = SHA256(SHA256(cast[ptr uint8](addrData), AddrMsgLen), SHA256Len)

  for ii in 0 ..< AddrChecksumLen:
    if doubleHash[ii].uint8 != addrData[AddrChecksumOffset + ii]:
      return false

  return true

proc main() =
  let
    testVectors : seq[string] = @[
      "3yQ",
      "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9",
      "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
      "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nJ9",
      "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62I",
      "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62ix",
      "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62ixx",
      "17NdbrSGoUotzeGCcMMCqnFkEvLymoou9j",
      "1badbadbadbadbadbadbadbadbadbadbad",
      "16UwLL9Risc3QfPqBUvKofHmBQ7wMtjvM",
      "1111111111111111111114oLvT2",
      "BZbvjr",
    ]

  var
    buf: array[AddrLen, uint8]
    astr: string

  for vector in testVectors:
    stdout.write(vector & " : ")
    try:
      if vector[0] notin {'1', '3'}:
        raise newException(ValueError, "invalid starting character")
      if vector.len < 26:
        raise newException(ValueError, "address too short")

      decodeBase58(vector, buf)

      if buf[0] != 0:
        stdout.write("NG - invalid version number\n")
      elif verifyChecksum(buf):
        stdout.write("OK\n")
      else:
        stdout.write("NG - checksum invalid\n")

    except:
      stdout.write("NG - " & getCurrentExceptionMsg() & "\n")

main()
