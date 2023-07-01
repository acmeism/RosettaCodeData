import strutils

proc reverse(a: string): string =
  result = newString(a.len)
  for i, c in a:
    result[a.high - i] = c

const digits = "0123456789abcdefghijklmnopqrstuvwxyz"

proc toBase[T](num: T, base: range[2..36]): string =
  if num == 0: return "0"
  result = ""
  if num < 0: result.add '-'
  var tmp = abs(num)
  var s = ""
  while tmp > 0:
    s.add digits[int(tmp mod base)]
    tmp = tmp div base
  result.add s.reverse

proc fromBase(str: string, base: range[2..36]): BiggestInt =
  var str = str
  let first = if str[0] == '-': 1 else: 0

  for i in first .. str.high:
    let c = str[i].toLowerAscii
    assert c in digits[0 ..< base]
    result = result * base + digits.find c

  if first == 1: result *= -1

echo 26.toBase 16
echo "1a".fromBase 16
