import algorithm, random, sequtils, strutils, sugar, tables

const Adfgvx = "ADFGVX"

type PolybiusSquare = array[6, array[6, char]]


iterator items(p: PolybiusSquare): (int, int, char) =
  ## Yield Polybius square characters preceded by row and column numbers.
  for r in 0..5:
    for c in 0..5:
      yield (r, c, p[r][c])


proc initPolybiusSquare(): PolybiusSquare =
  ## Initialize a 6x6 Polybius square.
  var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  alphabet.shuffle()
  for r in 0..5:
    for c in 0..5:
      result[r][c] = alphabet[6 * r + c]


proc createKey(n: Positive): string =
  ## Create a key using a word from "unixdict.txt".
  doAssert n in 7..12, "Key should be within 7 and 12 letters long."
  let candidates = collect(newSeq):
                   for word in "unixdict.txt".lines:
                     if word.len == n and
                        word.deduplicate().len == n and
                        word.allCharsInSet(Letters + Digits): word
  result = candidates[rand(candidates.high)].toUpperAscii


func encrypt(plainText: string; polybius: PolybiusSquare; key: string): string =
  ## Encrypt "plaintext" using the given Polybius square and the given key.

  # Replace characters by row+column letters.
  var str: string
  for ch in plainText:
    for (r, c, val) in polybius:
      if val == ch:
        str.add Adfgvx[r] & Adfgvx[c]

  # Build ordered table of columns and sort it by key value.
  var cols: OrderedTable[char, string]
  for i, ch in str:
    let tkey = key[i mod key.len]
    cols.mgetOrPut(tkey, "").add ch
  cols.sort(cmp)

  # Build cipher text from sorted column table values.
  for s in cols.values:
    result.addSep(" ")
    result.add s


func decrypt(cipherText: string; polybius: PolybiusSquare; key: string): string =
  ## Decrypt "cipherText" using the given Polybius square and the given key.

  # Build list of columns.
  let skey = sorted(key)
  var cols = newSeq[string](key.len)
  var idx = 0
  for col in cipherText.split(' '):
    cols[key.find(skey[idx])] = col
    inc idx

  # Build string of row+column values.
  var str: string
  for i in 0..key.high:
    for col in cols:
      if i < col.len: str.add col[i]

  # Build plain text from row+column values.
  for i in countup(0, str.len - 2, 2):
    let r = Adfgvx.find(str[i])
    let c = Adfgvx.find(str[i+1])
    result.add polybius[r][c]


randomize()

var polybius = initPolybiusSquare()
echo "6 x 6 Polybius square:\n"
echo "  | A D F G V X"
echo "---------------"
for i, row in polybius:
  echo Adfgvx[i], " | ", row.join(" ")

let key = createKey(9)
echo "\nThe key is ", key

const PlainText = "ATTACKAT1200AM"
echo "\nPlaintext : ", PlainText

let cipherText = PlainText.encrypt(polybius, key)
echo "\nEncrypted : ", cipherText

let plainText = cipherText.decrypt(polybius, key)
echo "\nDecrypted : ", plainText
