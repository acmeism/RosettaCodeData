import algorithm, sequtils, strformat

const SymbolTable = toSeq('a'..'z')

func encode(s: string): seq[int] =
  var symtable: seq[char] = SymbolTable
  for c in s:
    let idx = symtable.find(c)
    result.add idx
    symtable.rotateLeft(0..idx, -1)

func decode(s: seq[int]): string =
  var symtable = SymbolTable
  for idx in s:
    result.add symtable[idx]
    symtable.rotateLeft(0..idx, -1)

for word in ["broood", "babanaaa", "hiphophiphop"]:
  let encoded = word.encode()
  let decoded = encoded.decode()
  let status = if decoded == word: "correctly" else: "incorrectly"
  echo &"'{word}' encodes to {encoded} which {status} decodes to '{decoded}'."
