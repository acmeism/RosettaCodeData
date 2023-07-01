import strformat

const
  DigitRange = '0'..'9'
  UpperCaseRange = 'A'..'Z'

type ISINError = object of ValueError


proc luhn(s: string): bool =
  const m = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
  var sum = 0
  var odd = true
  for i in countdown(s.high, 0):
    let digit = ord(s[i]) - ord('0')
    sum += (if odd: digit else: m[digit])
    odd = not odd
  result = sum mod 10 == 0


proc validateISIN(s: string) =
  if s.len != 12:
    raise newException(ISINError, "wrong length")
  if s[0] notin UpperCaseRange or s[1] notin UpperCaseRange:
    raise newException(ISINError, "wrong country code")
  if s[11] notin DigitRange:
    raise newException(ISINError, "wrong checksum character")
  var t: string
  for ch in s:
    case ch
    of '0'..'9': t.add ch
    of 'A'..'Z': t.addInt ord(ch) - ord('A') + 10
    else: raise newException(ISINError, "invalid characters in code")
  if not t.luhn():
    raise newException(ISINError, "checksum error")


when isMainModule:

  for isin in ["US0378331005", "US0373831005", "U50378331005",
               "US03378331005", "AU0000XVGZA3", "AU0000VXGZA3", "FR0000988040"]:
    try:
      isin.validateISIN()
      echo &"{isin} is valid."
    except ISINError:
      echo &"{isin} is not valid: {getCurrentExceptionMsg()}."
