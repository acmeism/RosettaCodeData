import strutils

proc cusipCheck(cusip: string): bool =
  if cusip.len != 9:
    return false

  var
    sum, v = 0
  for i, c in cusip[0 .. ^2]:
    if c.isDigit:
      v = parseInt($c)
    elif c.isUpperAscii:
      v = ord(c) - ord('A') + 10
    elif c == '*':
      v = 36
    elif c == '@':
      v = 37
    elif c == '#':
      v = 38

    if i mod 2 == 1:
      v *= 2

    sum += v div 10 + v mod 10
  let check = (10 - (sum mod 10)) mod 10
  return $check == $cusip[^1]

proc main =
  let codes = [
    "037833100",
    "17275R102",
    "38259P508",
    "594918104",
    "68389X106",
    "68389X105"
  ]

  for code in codes:
    echo code, ": ", if cusipCheck(code): "Valid" else: "Invalid"

main()
