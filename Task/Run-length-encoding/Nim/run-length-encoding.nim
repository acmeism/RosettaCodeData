import strutils

type RunLength = tuple[c: char, n: int]

proc encode(inp): seq[RunLength] =
  result = @[]
  var count = 1
  var prev: char

  for c in inp:
    if c != prev:
      if prev != chr(0):
        result.add((prev,count))
      count = 1
      prev = c
    else:
      inc(count)
  result.add((prev,count))

proc decode(lst: openarray[RunLength]): string =
  result = ""
  for x in lst:
    result.add(repeatChar(x.n, x.c))

echo encode("aaaaahhhhhhmmmmmmmuiiiiiiiaaaaaa")
echo decode([('a', 5), ('h', 6), ('m', 7), ('u', 1), ('i', 7), ('a', 6)])
