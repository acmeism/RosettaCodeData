import strutils

for i in 0 .. 32:
  echo i, " => ", toBin(grayEncode(i), 6), " => ", grayDecode(grayEncode(i))
