import strformat, strutils

func pancake(n: int): int =
  var
    gap, sumGaps = 2
    pg = 1
    adj = -1
  while sumGaps < n:
    inc adj
    inc pg, gap
    swap pg, gap
    inc sumGaps, gap
  result = n + adj

var line = ""
for n in 1..20:
  line.addSep("   ")
  line.add &"p({n:>2}) = {pancake(n):>2}"
  if n mod 5 == 0: (echo line; line.setLen(0))
