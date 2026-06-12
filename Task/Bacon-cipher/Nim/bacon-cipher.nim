import strutils, sugar, tables

const Codes = {'a': "AAAAA", 'b': "AAAAB", 'c': "AAABA", 'd': "AAABB", 'e': "AABAA",
               'f': "AABAB", 'g': "AABBA", 'h': "AABBB", 'i': "ABAAA", 'j': "ABAAB",
               'k': "ABABA", 'l': "ABABB", 'm': "ABBAA", 'n': "ABBAB", 'o': "ABBBA",
               'p': "ABBBB", 'q': "BAAAA", 'r': "BAAAB", 's': "BAABA", 't': "BAABB",
               'u': "BABAA", 'v': "BABAB", 'w': "BABBA", 'x': "BABBB", 'y': "BBAAA",
               'z': "BBAAB", ' ': "BBBAA"}.toTable

let RevCodes = collect(newTable, for k, v in Codes.pairs: {v: k})

proc encode(plaintext, message: string): string =
  var et: string
  for c in plaintext.toLowerAscii:
    et.add if c in 'a'..'z': Codes[c] else: Codes[' ']
  var count = 0
  for c in message.toLowerAscii:
    if c in 'a'..'z':
      result.add if et[count] == 'A': c else: c.toUpperAscii
      inc count
      if count == et.len: break
    else:
      result.add c


proc decode(message: string): string =
  var et: string
  for c in message:
    if c.isAlphaAscii:
      et.add if c.isLowerAscii: 'A' else: 'B'
  for i in countup(0, et.high - 4, 5):
    result.add RevCodes[et[i..(i+4)]]


when isMainModule:
  const
    PlainText = "the quick brown fox jumps over the lazy dog"
    Message = "bacon's cipher is a method of steganography created by francis bacon." &
              "this task is to implement a program for encryption and decryption of " &
              "plaintext using the simple alphabet of the baconian cipher or some " &
              "other kind of representation of this alphabet (make anything signify anything). " &
              "the baconian alphabet may optionally be extended to encode all lower " &
              "case characters individually and/or adding a few punctuation characters " &
              "such as the space."
  let cipherText = PlainText.encode(Message)
  echo "Cipher text →\n", cipherText
  let decodedText = cipherText.decode()
  echo "\nHidden text →\n", decodedText
