import strutils

proc isAlpha(c): bool = c in 'a'..'z' or c in 'A'..'Z'

proc encrypt(msg, key): string =
  result = ""
  var pos = 0
  for c in msg:
    if isAlpha c:
      result.add chr(((ord(key[pos]) + ord(toUpper c)) mod 26) + ord('A'))
      pos = (pos + 1) mod key.len

proc decrypt(msg, key): string =
  result = ""
  var pos = 0
  for c in msg:
    result.add chr(((26 + ord(c) - ord(key[pos])) mod 26) + ord('A'))
    pos = (pos + 1) mod key.len

const text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
const key = "VIGENERECIPHER"

let encr = encrypt(text, key)
let decr = decrypt(encr, key)

echo text
echo encr
echo decr
