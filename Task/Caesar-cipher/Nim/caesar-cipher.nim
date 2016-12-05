import strutils

proc caesar(s: string, k: int, decode = false): string =
  var k = if decode: 26 - k else: k
  result = ""
  for i in toUpper(s):
    if ord(i) >= 65 and ord(i) <= 90:
      result.add(chr((ord(i) - 65 + k) mod 26 + 65))

let msg = "The quick brown fox jumped over the lazy dogs"
echo msg
let enc = caesar(msg, 11)
echo enc
echo caesar(enc, 11, decode = true)
