import strutils, tables

const
  FullStop = '.'
  Escape = '/'

type Checkerboard = object
  encryptTable: Table[char, string]
  decryptTable: Table[string, char]


proc initCheckerboard(digits: string; row1, row2, row3: string): Checkerboard =
  ## Initialize a checkerboard with given digits in row 0 and the following given rows.
  ## No sanity check is performed.

  var rowChars: seq[char]   # The two characters to use to identify rows 2 and 3.

  # Process row 1.
  for col, ch in row1:
    if ch == ' ':
      rowChars.add digits[col]
    else:
      result.encryptTable[ch] = $digits[col]
  if rowChars.len != 2:
    raise newException(ValueError, "expected two blank spots in first letter row.")

  # Add rows 2 and 3.
  for col, ch in row2:
    result.encryptTable[ch] = rowChars[0] & digits[col]
  for col, ch in row3:
    result.encryptTable[ch] = rowChars[1] & digits[col]
  if Escape notin result.encryptTable:
    raise newException(ValueError, "missing Escape character.")

  # Build decrypt table from encrypt table.
  for c, s in result.encryptTable.pairs:
    result.decryptTable[s] = c


proc encrypt(board: Checkerboard; message: string): string =
  ## Encrypt a string.

  let message = message.toUpperAscii
  for ch in message:
    case ch
    of 'A'..'Z', FullStop, Escape:
      result.add board.encryptTable[ch]
    of '0'..'9':
      result.add board.encryptTable[Escape]
      result.add ch
    else:
      discard   # Ignore other characters.


proc raiseError() =
  ## Raise a ValueError to signal a corrupt message.
  raise newException(ValueError, "corrupt message")


proc decrypt(board: Checkerboard; message: string): string =
  ## Decrypt a message.

  var escaped = false   # Escape char previously encountered.
  var str = ""          # Current sequence of characters (contains 0, 1 or 2 chars).

  for ch in message:
    if ch notin '0'..'9': raiseError()

    if escaped:
      # Digit is kept as is.
      result.add ch
      escaped = false
    else:
      # Try to decrypt this new digit.
      str.add ch
      if str in board.decryptTable:
        let c = board.decryptTable[str]
        if c == Escape: escaped = true
        else: result.add c
        str.setLen(0)
      elif str.len == 2:
        # Illegal combination of two digits.
        raiseError()

when isMainModule:
  let board = initCheckerboard("8752390146", "ET AON RIS", "BC/FGHJKLM", "PQD.VWXYZU")
  let message = "you have put on 7.5 pounds since I saw you."
  echo "Message: ", message
  let crypted = board.encrypt(message)
  echo "Crypted: ", crypted
  echo "Decrypted: ", board.decrypt(crypted)
