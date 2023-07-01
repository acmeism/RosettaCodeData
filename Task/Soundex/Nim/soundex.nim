import strutils

const
  Wovel = 'W'   # Character code used to specify a wovel.
  Ignore = ' '  # Character code used to specify a character to ignore ('h', 'w' or non-letter).


proc code(ch: char): char =
  ## Return the soundex code for a character.
  case ch.toLowerAscii()
  of 'b', 'f', 'p', 'v': '1'
  of 'c', 'g', 'j', 'k', 'q', 's', 'x', 'z': '2'
  of 'd', 't': '3'
  of 'l': '4'
  of 'm', 'n': '5'
  of 'r': '6'
  of 'a', 'e', 'i', 'o', 'u', 'y': Wovel
  else: Ignore

proc soundex(str: string): string =
  ## Return the soundex for the given string.

  result.add str[0]   # Store the first letter.

  # Process characters.
  var prev = code(str[0])
  for i in 1..str.high:
    let curr = code(str[i])
    if curr != Ignore:
      if curr != Wovel and curr != prev:
        result.add curr
      prev = curr

  # Make sure the result has four characters.
  if result.len > 4:
    result.setLen(4)
  else:
    for _ in result.len..3:
      result.add '0'


for name in ["Robert", "Rupert", "Rubin", "Ashcraft", "Ashcroft", "Tymczak",
             "Pfister", "Honeyman", "Moses", "O'Mally", "O'Hara", "D day"]:
  echo name.align(8), " ", soundex(name)
