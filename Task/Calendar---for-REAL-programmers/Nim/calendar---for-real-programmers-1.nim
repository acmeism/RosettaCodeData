import strutils

const progUpper = staticRead("calendar_upper.txt")

proc transformed(s: string): string {.compileTime.} =
  ## Return a transformed version (which can compile) of a program in uppercase.

  let upper = s.toLower() # Convert all to lowercase.
  var inString = false    # Text in string should be in uppercase…
  var inBraces = false    # … except if this is in an expression to interpolate.
  for ch in upper:
    case ch
    of '"':
      inString = not inString
    of '{':
      if inString: inBraces = true
    of '}':
      if inString: inBraces = false
    of 'a'..'z':
      if inString and not inBraces:
        result.add(ch.toUpperAscii())   # Restore content of strings to uppercase.
        continue
    else:
      discard
    result.add(ch)

const prog = progUpper.transformed()

static: writeFile("calendar_transformed.nim", prog)

include "calendar_transformed.nim"
