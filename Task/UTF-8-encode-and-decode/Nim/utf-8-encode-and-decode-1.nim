import unicode, sequtils, strformat, strutils

const UChars = ["\u0041", "\u00F6", "\u0416", "\u20AC", "\u{1D11E}"]

proc toSeqByte(r: Rune): seq[byte] =
  let s = r.toUTF8
  result = @(s.toOpenArrayByte(0, s.high))

proc toRune(s: seq[byte]): Rune =
  s.mapIt(chr(it)).join().toRunes[0]

echo "Character  Unicode  UTF-8 encoding (hex)"
for uchar in UChars:
  # Convert the UTF-8 string to a rune (codepoint).
  var r = uchar.toRunes[0]
  # Convert the rune to a sequence of bytes.
  let s = r.toSeqByte
  # Convert back the sequence of bytes to a rune.
  r = s.toRune
  # Display.
  echo &"""{uchar:>5}      U+{r.int.toHex(5)}  {s.map(toHex).join(" ")}"""
