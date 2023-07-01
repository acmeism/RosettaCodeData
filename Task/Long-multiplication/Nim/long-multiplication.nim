import strutils

proc ti(a: char): int = ord(a) - ord('0')

proc longmulti(a, b: string): string =
  var
    i, j = 0
    k = false

  # either is zero, return "0"
  if a == "0" or b == "0":
    return "0"

  # see if either a or b is negative
  if a[0] == '-':
    i = 1; k = not k
  if b[0] == '-':
    j = 1; k = not k

  # if yes, prepend minus sign if needed and skip the sign
  if i > 0 or j > 0:
    result = if k: "-" else: ""
    result.add longmulti(a[i..a.high], b[j..b.high])
    return

  result = repeat('0', a.len + b.len)

  for i in countdown(a.high, 0):
    var carry = 0
    var k = i + b.len
    for j in countdown(b.high, 0):
      let n = ti(a[i]) * ti(b[j]) + ti(result[k]) + carry
      carry = n div 10
      result[k] = chr(n mod 10 + ord('0'))
      dec k
    result[k] = chr(ord(result[k]) + carry)

  if result[0] == '0':
    result[0..result.high-1] = result[1..result.high]

echo longmulti("-18446744073709551616", "-18446744073709551616")
