import bitops, strutils

func ownCalcPass(password, nonce: string): uint32 =

  var start = true

  for c in nonce:
    if c != '0' and start:
      result = parseInt(password).uint32
      start = false
    case c
    of '0':
      discard
    of '1':
      result = result.rotateRightBits(7)
    of '2':
      result = result.rotateRightBits(4)
    of '3':
      result = result.rotateRightBits(3)
    of '4':
      result = result.rotateLeftBits(1)
    of '5':
      result = result.rotateLeftBits(5)
    of '6':
      result = result.rotateLeftBits(12)
    of '7':
      result = (result and 0x0000FF00) or result shl 24  or
               (result and 0x00FF0000) shr 16 or (result and 0xFF000000u32) shr 8
    of '8':
      result = result shl 16 or result shr 24 or (result and 0x00FF0000) shr 8
    of '9':
      result = not result
    else:
      raise newException(ValueError, "non-digit in nonce.")


when isMainModule:

  proc testPasswordCalc(password, nonce: string; expected: uint32) =

    let res = ownCalcPass(password, nonce)
    let m = "$# $# $# $#".format(password, nonce, res, expected)
    echo if res == expected: "PASS " else: "FAIL ", m

  testPasswordCalc("12345", "603356072", 25280520u32)
  testPasswordCalc("12345", "410501656", 119537670u32)
  testPasswordCalc("12345", "630292165", 4269684735u32)
