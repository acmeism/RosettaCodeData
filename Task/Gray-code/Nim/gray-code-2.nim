import strutils, strformat

for i in 0 .. 32:
  echo &"{i:>2} => {toBin(grayEncode(i), 6)} => {grayDecode(grayEncode(i)):>2}"
