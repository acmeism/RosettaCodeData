import os, osproc, strutils

const S = "Actions speak louder than words."

var prev, bs = ""
var prevlen = 0

for word in S.splitWhitespace():
  discard execProcess("espeak " & word)
  if prevlen > 0:
    bs = repeat('\b', prevlen)
  stdout.write bs, prev, word.toUpper, ' '
  stdout.flushFile()
  prev = word & ' '
  prevlen = word.len + 1

bs = repeat('\b', prevlen)
sleep(1000)
echo bs, prev
