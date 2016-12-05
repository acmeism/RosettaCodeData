import strutils, algorithm

var strings = "here are Some sample strings to be sorted".split(' ')

strings.sort(proc (x,y: string): int =
  cmp(y.len, x.len))

echo strings
