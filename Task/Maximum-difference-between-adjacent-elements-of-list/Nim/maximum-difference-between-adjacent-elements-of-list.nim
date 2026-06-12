import strformat, strutils

type Pair = (float, float)

func `$`(p: Pair): string = &"({p[0]:g}, {p[1]:g})"

func maxdiff(list: openArray[float]): tuple[diff: float; list: seq[Pair]] =
  assert list.len >= 2
  result = (diff: -1.0, list: @[])
  var prev = list[0]
  for n in list[1..^1]:
    let d = abs(n - prev)
    if d > result.diff:
      result.diff = d
      result.list = @[(prev, n)]
    elif d == result.diff:
      result.list.add (prev, n)
    prev = n

let list = [float 1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8, 6, 2, 9, 11, 10, 3]
let (diff, pairs) = list.maxdiff()

echo &"The maximum difference between adjacent pairs of the list is: {diff:g}"
echo "The pairs with this difference are: ", pairs.join(" ")
