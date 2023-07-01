import strutils, streams, strformat
# nimble install stint
import stint

const messages = ["PPAP", "I have a pen, I have a apple\nUh! Apple-pen!",
    "I have a pen, I have pineapple\nUh! Pineapple-pen!",
    "Apple-pen, pineapple-pen\nUh! Pen-pineapple-apple-pen\nPen-pineapple-apple-pen\nDance time!", "\a\0"]
const
  n = u256("9516311845790656153499716760847001433441357")
  e = u256("65537")
  d = u256("5617843187844953170308463622230283376298685")
proc pcount(s: string, c: char): int{.inline.} =
  for ch in s:
    if ch != c:
      break
    result+=1
func powmodHexStr(s: string, key, divisor: UInt256): string{.inline.} =
  toHex(powmod(UInt256.fromHex(s), key, divisor))
proc translate(hexString: string, key, divisor: UInt256,
    encrypt = true): string =
  var
    strm = newStringStream(hexString)
    chunk, residue, tempChunk: string
  let chunkSize = len(toHex(divisor))
  while true:
    tempChunk = strm.peekStr(chunkSize-int(encrypt)*3)
    if len(chunk) > 0:
      if len(tempChunk) == 0:
        if encrypt:
          result&=powmodHexStr(pcount(chunk, '0').toHex(2)&align(chunk,
              chunkSize-3, '0'), key, divisor)
        else:
          tempChunk = align(powmodHexStr(chunk, key, divisor), chunkSize-1, '0')
          residue = tempChunk[2..^1].strip(trailing = false, chars = {'0'})
          result&=align(residue, fromHex[int](tempChunk[0..1])+len(residue), '0')
        break
      result&=align(powmodHexStr(chunk, key, divisor), chunkSize-3+int(
          encrypt)*3, '0')
    discard strm.readStr(chunkSize-int(encrypt)*3)
    chunk = tempChunk
  strm.close()
for message in messages:
  echo(&"plaintext:\n{message}")
  var numPlaintext = message.toHex()
  echo(&"numerical plaintext in hex:\n{numPlaintext}")
  var ciphertext = translate(numPlaintext, e, n)
  echo(&"ciphertext is: \n{ciphertext}")
  var deciphertext = translate(ciphertext, d, n, false)
  echo(&"deciphered numerical plaintext in hex is:\n{deciphertext}")
  echo(&"deciphered plaintext is:\n{parseHexStr(deciphertext)}\n\n")
