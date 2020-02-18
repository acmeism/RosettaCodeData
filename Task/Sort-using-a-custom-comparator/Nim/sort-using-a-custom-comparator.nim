import strutils, algorithm

var strings = "here are Some sample strings to be sorted".split(' ')

strings.sort(proc (x, y: string): int =
  result = cmp(y.len, x.len)
  if result == 0:
    result = cmpIgnoreCase(x, y)
)

echo strings
