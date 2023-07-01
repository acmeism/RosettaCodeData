import strutils

proc encrypt(msg, key: string): string =
  var pos = 0
  for c in msg:
    if c in Letters:
      result.add chr(((ord(key[pos]) + ord(c.toUpperAscii)) mod 26) + ord('A'))
      pos = (pos + 1) mod key.len

proc decrypt(msg, key: string): string =
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
