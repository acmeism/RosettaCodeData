import std/[algorithm, math, strutils, sugar]

func isSquare(n: Natural): bool =
  let r = sqrt(n.toFloat).int
  result = n == r * r

const
  List1 = @[3, 4, 34, 25, 9, 12, 36, 56, 36]
  List2 = @[2, 8, 81, 169, 34, 55, 76, 49, 7]
  List3 = @[75, 121, 75, 144, 35, 16, 46, 35]

var squareList = collect:
                   for list in [List1, List2, List3]:
                     for n in list:
                       if n.isSquare:
                         n
squareList.sort()

echo squareList.join(" ")
