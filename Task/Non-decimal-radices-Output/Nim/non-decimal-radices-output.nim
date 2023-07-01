import strutils

for i in 0..33:
  echo toBin(i, 6)," ",toOct(i, 3)," ",align($i,2)," ",toHex(i,2)
