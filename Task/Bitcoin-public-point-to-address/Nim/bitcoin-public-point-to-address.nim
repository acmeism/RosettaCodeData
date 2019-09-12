import parseutils
import base58 / bitcoin
import nimcrypto / [hash, sha2, ripemd]

func hexToByteSeq(s: string): seq[byte] =
  var pos = 0
  while pos < s.len:
    var tmp = 0
    let parsed = parseHex(s, tmp, pos, 2)
    if parsed > 0:
      inc pos, parsed
      result.add byte tmp
    else:
      raise newException(ValueError, "Invalid hex string")

func addrEncode(x, y: string): string =
  let pubPoint = 4u8 & x.hexToByteSeq & y.hexToByteSeq
  if pubPoint.len != 65:
    raise newException(ValueError, "Invalid pubpoint string")
  var rmd = @(ripemd160.digest(sha256.digest(pubPoint).data).data)
  rmd.insert 0u8
  rmd.add sha256.digest(sha256.digest(rmd).data).data[0..3]
  result = encode cast[string](rmd)

when isMainModule:
  echo addrEncode("50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352",
                  "2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6")
