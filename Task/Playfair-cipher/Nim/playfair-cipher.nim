import pegs, strutils

type
  Position = tuple[x, y: int]
  Playfair = object
    positions: array['A'..'Z', Position]
    table: array[5, array[5, char]]

const None: Position = (-1, -1)   # Default value for positions.


proc initPlayfair(key: string; jti: bool): Playfair =

  for item in result.positions.mitems: item = None

  var alphabet = key & "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  alphabet = if jti: alphabet.replace('J', 'I')
             else: alphabet.replace("Q", "")

  var k = 0
  for ch in alphabet:
    if result.positions[ch] == None:
      result.table[k div 5][k mod 5] = ch
      result.positions[ch] = (k mod 5, k div 5)
      inc k


proc codec(playfair: Playfair; text: string; direction: int): string =

  result.setLen(text.len)

  for i in countup(0, text.high, 2):
    var
      (col1, row1) = playfair.positions[text[i]]
      (col2, row2) = playfair.positions[text[i + 1]]

    if row1 == row2:
      col1 = (col1 + direction) mod 5
      col2 = (col2 + direction) mod 5
    elif col1 == col2:
      row1 = (row1 + direction) mod 5
      row2 = (row2 + direction) mod 5
    else:
      swap col1, col2

    result[i] = playfair.table[row1][col1]
    result[i + 1] = playfair.table[row2][col2]


proc encode(playfair: Playfair; text: string): string =
  var
    text = text
    i = 0

  while i < text.len:
    if i == text.high:
      if (text.len and 1) != 0:
        text.add 'X'
    elif text[i] == text[i + 1]:
      text.insert("X", i + 1)
    inc i, 2

  result = playfair.codec(text, 1)


proc decode(playfair: Playfair; text: string): string =
  result = playfair.codec(text, 4)


proc prompt(msg: string): string =
  stdout.write msg
  try:
    result = stdin.readLine()
  except EOFError:
    echo ""
    quit getCurrentExceptionMsg(), QuitFailure


when isMainModule:

  var key: string
  while key.len <= 6:
    key = prompt("Enter an encryption key (min letters 6): ").toUpperAscii().replace(peg"[^A-Z]")

  var text: string
  while text.len == 0:
    text = prompt("Enter the message: ").toUpperAscii().replace(peg"[^A-Z]")

  var answer: string
  while answer notin ["y", "n"]:
    answer = prompt("Replace J with I? y/n: ").toLowerAscii()
  let jti = (answer == "y")

  let playfair = initPlayfair(key, jti)
  let enc = playfair.encode(text)
  let dec = playfair.decode(enc)

  echo "Encoded message: ", enc
  echo "Decoded message: ", dec
