import strutils

proc reverseWord(ch: var char) =
  var nextch = stdin.readChar()
  if nextch.isAlphaAscii():
    reverseWord(nextch)
  stdout.write(ch)
  ch = nextch

proc normalWord(ch: var char) =
  stdout.write(ch)
  ch = stdin.readChar()
  if ch.isAlphaAscii():
    normalWord(ch)

var ch = stdin.readChar()

while ch != '.':
  normalWord(ch)
  if ch != '.':
    stdout.write(ch)
    ch = stdin.readChar()
    reverseWord(ch)
stdout.write(ch)
