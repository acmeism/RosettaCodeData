import algorithm, sequtils, strutils, future

proc maxNum(x: seq[int]): string =
  var c = x.mapIt(string, $it)
  c.sort((x, y) => cmp(y&x, x&y))
  c.join()

echo maxNum(@[1, 34, 3, 98, 9, 76, 45, 4])
echo maxNum(@[54, 546, 548, 60])
