import unicode

proc readUtf8(f: File): string =
  ## Return next UTF-8 character as a string.
  while true:
    result.add f.readChar()
    if result.validateUtf8() == -1: break

iterator readUtf8(f: File): string =
  ## Yield successive UTF-8 characters from file "f".
  var res: string
  while not f.endOfFile:
    res.setLen(0)
    while true:
      res.add f.readChar()
      if res.validateUtf8() == -1: break
    yield res
